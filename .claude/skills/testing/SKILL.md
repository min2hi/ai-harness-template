# Testing Rules

> Stack: pytest + pytest-asyncio + httpx + Testcontainers + schemathesis

## Test Pyramid

```
E2E Tests       (schemathesis)     ← Auto-test toàn bộ API theo OpenAPI spec
Integration     (httpx + Testcontainers) ← Test endpoint với DB thật
Unit Tests      (pytest)           ← Test service/utility logic
ML Tests        (pytest)           ← FeatureExtractor parity train vs serve
```

## Naming Convention

```
backend/src/services/task.service.py
                    ↓
backend/tests/unit/test_task_service.py
backend/tests/integration/test_task_api.py
```

## Shared Fixtures (conftest.py)

```python
# backend/tests/conftest.py
import pytest
from httpx import AsyncClient
from testcontainers.postgres import PostgresContainer
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession

@pytest.fixture(scope="session")
def postgres_container():
    """PostgreSQL thật — không mock DB."""
    with PostgresContainer("postgres:16") as pg:
        yield pg

@pytest.fixture
async def db_session(postgres_container):
    engine = create_async_engine(postgres_container.get_connection_url())
    async with AsyncSession(engine) as session:
        yield session
        await session.rollback()   # Cleanup sau mỗi test

@pytest.fixture
async def client(db_session):
    """FastAPI test client với DB thật."""
    app.dependency_overrides[get_db] = lambda: db_session
    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac
```

## Unit Test Pattern

```python
# backend/tests/unit/test_task_service.py
import pytest
from unittest.mock import AsyncMock, MagicMock

class TestTaskService:
    async def test_create_task_success(self, db_session, mock_user):
        service = TaskService(db_session)
        dto = CreateTaskDto(title="Write unit tests", priority=2)

        result = await service.create(dto, mock_user)

        assert result.title == "Write unit tests"
        assert result.org_id == mock_user.org_id

    async def test_create_task_empty_title_raises(self, db_session, mock_user):
        service = TaskService(db_session)
        with pytest.raises(ValueError, match="Title không được để trống"):
            await service.create(CreateTaskDto(title="  "), mock_user)

    async def test_create_task_enforces_org_id(self, db_session, mock_user):
        """Ensure multi-tenancy — org_id always set from user, not body."""
        service = TaskService(db_session)
        result = await service.create(CreateTaskDto(title="Test"), mock_user)
        assert result.org_id == mock_user.org_id
```

## Integration Test Pattern

```python
# backend/tests/integration/test_task_api.py
class TestTaskAPI:
    async def test_create_task_requires_auth(self, client):
        resp = await client.post("/api/v1/tasks/", json={"title": "test"})
        assert resp.status_code == 401

    async def test_create_task_idempotency(self, client, auth_headers):
        """Same idempotency key → same result, no duplicate."""
        headers = {**auth_headers, "idempotency-key": "test-key-123"}
        resp1 = await client.post("/api/v1/tasks/", json={"title": "T"}, headers=headers)
        resp2 = await client.post("/api/v1/tasks/", json={"title": "T"}, headers=headers)

        assert resp1.status_code == 201
        assert resp2.status_code == 200        # Not 201 — from cache
        assert resp1.json()["data"]["id"] == resp2.json()["data"]["id"]

    async def test_rbac_member_cannot_delete_project(self, client, member_auth_headers):
        resp = await client.delete("/api/v1/projects/some-id", headers=member_auth_headers)
        assert resp.status_code == 403
```

## ML-Specific Tests (BẮT BUỘC)

```python
# backend/tests/ml/test_feature_extractor.py
class TestFeatureExtractorParity:
    """Đảm bảo training và serving tạo ra CÙNG features."""

    def test_extract_from_orm_equals_extract_from_dict(self, sample_task_orm, sample_task_dict):
        """Training path (ORM) vs Serving path (dict) phải cho kết quả giống nhau."""
        extractor = TaskFeatureExtractor()
        orm_features  = extractor.extract(sample_task_orm)
        dict_features = extractor.extract(sample_task_dict)
        assert orm_features == dict_features, "Training-Serving SKEW detected!"

    def test_all_required_features_present(self, sample_task):
        features = TaskFeatureExtractor().extract(sample_task)
        required = ["title_len", "priority_score", "has_deadline", "dependency_count"]
        for f in required:
            assert f in features, f"Feature '{f}' missing!"
```

## Factory Functions (không hardcode data)

```python
# backend/tests/factories.py
from factory import Factory, LazyFunction, Faker
import uuid

class TaskFactory(Factory):
    class Meta:
        model = dict

    id          = LazyFunction(lambda: str(uuid.uuid4()))
    title       = Faker("sentence", nb_words=4)
    priority    = Faker("random_int", min=1, max=5)
    org_id      = LazyFunction(lambda: str(uuid.uuid4()))
    created_by  = LazyFunction(lambda: str(uuid.uuid4()))
    status      = "todo"

# Dùng:
task = TaskFactory()
tasks = TaskFactory.build_batch(10)
```

## CI Gate Rules

```
GitHub Actions phải block merge nếu:
  → pytest coverage < 70%
  → Bất kỳ test nào fail
  → ML parity test fail (Training-Serving Skew detected)

Lệnh CI:
  pytest --cov=src --cov-report=xml --cov-fail-under=70
  schemathesis run --checks all openapi.yaml
```

## Mock Data Rules

- Mock data chỉ trong test file hoặc factories.py — KHÔNG trong production code
- Dùng Factory functions, không hardcode objects
- `afterEach` cleanup: `await session.rollback()` trong fixture
- Testcontainers cho PostgreSQL thật — không mock DB

## Self-Check

```
[ ] Testcontainers dùng PostgreSQL thật — không SQLite
[ ] conftest.py có session rollback sau mỗi test
[ ] ML parity test: ORM vs dict extract cho kết quả giống nhau
[ ] RBAC test: verify 403 khi sai role
[ ] Idempotency test: request trùng key không tạo duplicate
[ ] Factory functions thay vì hardcoded test data
[ ] Coverage >= 70% trước khi commit
[ ] Không có test bị skip mà không có lý do rõ ràng
```
