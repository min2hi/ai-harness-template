# {{PROJECT_NAME}} — Architecture Overview

> **Đọc file này khi:** hỏi về kiến trúc tổng thể, stack, luồng hệ thống.
> **Trạng thái:** <!-- TODO: Điền thông tin thực tế sau khi setup -->

## Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Backend | <!-- TODO: e.g. FastAPI + Python | Node.js + Express | Go Fiber --> | |
| Frontend | <!-- TODO: e.g. Next.js | React+Vite | Vue | None --> | |
| Mobile | <!-- TODO: e.g. Flutter | React Native | None --> | |
| Database | <!-- TODO: e.g. PostgreSQL | MySQL | MongoDB | SQLite --> | |
| ORM / ODM | <!-- TODO: e.g. Prisma | SQLAlchemy | Mongoose | GORM --> | |
| Cache | <!-- TODO: e.g. Redis | Memcached | None --> | |
| Auth | <!-- TODO: e.g. JWT | Session | Firebase | Supabase --> | |
| Queue | <!-- TODO: e.g. BullMQ | Celery | Sidekiq | None --> | |
| ML/AI | <!-- TODO: e.g. XGBoost+MLflow | HuggingFace | OpenAI | None --> | |
| Hosting | <!-- TODO: e.g. Docker+VPS | Vercel | Railway | AWS --> | |

## Project Structure

```
<!-- TODO: Điền cấu trúc thư mục thực tế -->
{{PROJECT_SLUG}}/
├── {{BACKEND_DIR}}/    ← Backend service
├── {{FRONTEND_DIR}}/   ← Frontend (nếu có)
├── .claude/            ← AI context & templates
├── .github/            ← CI/CD workflows
├── docs/               ← Documentation & ADRs
└── AGENTS.md           ← AI entry point
```

## Service Map

<!-- TODO: Điền ports thực tế -->
| Service | Port | Description |
|---------|------|-------------|
| Backend API | <!-- TODO --> | REST/GraphQL API |
| Frontend | <!-- TODO --> | Web UI |
| Database | <!-- TODO --> | Primary DB |
| Cache | <!-- TODO --> | (nếu có) |

## Key User Flows

<!-- TODO: Mô tả 3-5 luồng chính của hệ thống -->
<!-- Ví dụ:
1. User đăng ký → verify → login → nhận token
2. User tạo resource → validate → lưu DB → response
3. Background job → process → notify user
-->

## Environment Variables

<!-- TODO: Liệt kê env vars cần thiết — xem .env.example -->

## Architecture Decisions

<!-- TODO: Link đến các ADR quan trọng nhất -->
<!-- Ví dụ:
- [ADR-001](docs/adr/ADR-001-database-choice.md) — Tại sao chọn PostgreSQL
- [ADR-002](docs/adr/ADR-002-auth-strategy.md) — JWT vs Session
-->
