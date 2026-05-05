# Git Workflow

## Workflow Chuẩn

```
1. Lấy task mới
      ↓
2. Tìm hiểu code liên quan (grep / code intelligence tool)
      ↓
3. Kiểm tra blast radius nếu sửa code cũ
      ↓
4. Viết code
      ↓
5. [Nếu có quyết định kiến trúc] Tạo ADR trong docs/adr/
      ↓
6. Verify đúng scope: git diff --stat
      ↓
7. git add → git commit (message chuẩn Conventional Commits)
      ↓
8. gitnexus analyze → Re-index (không cần --embeddings cho bug fix/refactor)
```

---

## Conventional Commits

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types cơ bản:** `feat` | `fix` | `refactor` | `chore` | `docs` | `test` | `perf` | `style` | `ci` | `revert`

**Types ML/AI (bổ sung cho project này):**

| Type | Khi nào dùng |
|---|---|
| `ml` | Thay đổi training pipeline, hyperparameters, feature engineering |
| `data` | Thêm/sửa dataset (phải kèm `dvc push`) |
| `model` | Deploy/promote model version mới |
| `agent` | Thay đổi agent tools, prompts, HITL rules |

**Ví dụ:**
```bash
feat(tasks): add context_switch_count field to task schema
fix(api): handle null actual_time in drift monitor
ml(predictor): retrain xgboost with 50k samples, val_mae=1.1h
data(tasks): add 40k LLM-augmented samples, dvc tag dataset-v2.0
model(predictor): promote v1.3 from shadow to production, run_id=abc123
agent(research): add arxiv.org to SafeWebCrawler allowlist
docs(adr): add ADR-001 why we chose FastAPI over Django
```

**Sẽ bị chặn:**
```bash
"fix bug"          # ← thiếu type
"FEAT: add login"  # ← type phải lowercase
"feat: "           # ← thiếu description
```

---

## Branch Strategy

```
main       ← Production (protected, chỉ merge qua PR)
develop    ← Staging (protected)
feat/*     ← Feature branches (từ develop)
fix/*      ← Bug fix branches
ml/*       ← ML training/experiment branches
data/*     ← Dataset update branches (phải kèm DVC)
```

---

## ADR — Ghi Lại Quyết Định Kiến Trúc

### Khi nào tạo ADR?

| Tạo ADR | Không cần |
|---------|-----------|
| Chọn thư viện/framework mới | Bug fix, refactor nhỏ |
| Thay đổi kiến trúc có phạm vi lớn | Thêm field vào model |
| Trade-off rõ ràng được chọn | Thay đổi UI/style |
| Từ chối một cách tiếp cận | Update version (không đổi library) |

```bash
# Quy trình tạo ADR
cp docs/adr/ADR-000-template.md docs/adr/ADR-00N-ten-ngan.md
# Điền nội dung → commit CÙNG với code thay đổi
```

> **Nguyên tắc:** ADR viết cùng lúc hoặc trước khi code — không phải sau.

---

## Re-index GitNexus — Khi Nào & Lệnh Nào

> **Yêu cầu:** Cài global 1 lần khi setup: `npm install -g gitnexus@1.6.3`  
> ⚠️ KHÔNG dùng `npx gitnexus` trên Windows → gây EPERM (file-lock trên native .dll bindings)

```bash
# Sau bug fix / refactor (nhanh ~10s)
gitnexus analyze

# Sau khi thêm feature / service mới (chậm hơn, dùng AI embeddings)
gitnexus analyze --embeddings

# Nếu index bị corrupt (WAL error) → reset và rebuild
gitnexus clean --force
gitnexus analyze --embeddings
```

### Khi nào cần chạy?

| Sự kiện | Cần re-index? |
|---------|--------------|
| Sau commit có thêm/sửa source files (`.ts`, `.js`, `.py`, v.v.) | ✅ Có |
| Sau `git merge` | ✅ Có |
| Thêm service/controller mới | ✅ Có (`--embeddings`) |
| Chỉ sửa CSS, strings, comments | ❌ Không cần |
| Chỉ sửa config files | ❌ Không cần |

---

## DVC + MLflow Commit Rules

```
Quy tắc bắt buộc:

1. Mọi commit type `data` PHẢI:
   → dvc push trước khi git commit
   → git tag dataset-vX.Y cùng lúc
   → Commit message ghi rõ số records và nguồn data

2. Mọi commit type `model` PHẢI:
   → Ghi MLflow run_id vào commit body
   → Ghi stage cũ → stage mới (Shadow→Production)
   → Không promote thẳng từ Staging lên Production

3. Mọi commit type `ml` PHẢI:
   → Ghi validation metrics vào commit body (val_mae, val_rmse)
   → Đảm bảo FeatureExtractor không thay đổi (chống training-serving skew)
```

**Ví dụ commit body cho model promotion:**
```bash
model(predictor): promote v1.3 from shadow to production

MLflow run_id: abc123def456
Previous stage: Shadow (7 days)
val_mae: 1.1h → shadow_mae: 1.05h (improvement: 4.5%)
DVC dataset: dataset-v2.0
Approved by: @team-lead
```
