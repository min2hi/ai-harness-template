# {{PROJECT_NAME}} — Architecture Overview

> **Đọc file này khi:** hỏi về kiến trúc tổng thể, stack, luồng hệ thống.

## Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Backend | <!-- TODO: e.g. Node.js + Express + TypeScript --> | |
| Frontend | <!-- TODO: e.g. Next.js 14 (App Router) --> | |
| Mobile | <!-- TODO: e.g. Flutter --> | |
| Database | <!-- TODO: e.g. PostgreSQL (Neon) --> | |
| ORM | <!-- TODO: e.g. Prisma --> | |
| Auth | <!-- TODO: e.g. JWT --> | |
| AI/LLM | <!-- TODO: e.g. Gemini API --> | |
| Hosting | <!-- TODO: e.g. Render (BE), Vercel (FE) --> | |

## Project Structure

```
{{PROJECT_SLUG}}/
├── {{BACKEND_DIR}}/    ← Backend service
├── {{FRONTEND_DIR}}/   ← Web frontend
├── .claude/            ← AI context & templates
├── .github/            ← CI/CD workflows
├── docs/               ← Documentation & ADRs
└── AGENTS.md           ← AI entry point
```

## Service Map

<!-- TODO: Thêm service map và ports thực tế của dự án -->
<!-- Ví dụ:
| Service | Port | Description |
|---------|------|-------------|
| Backend API | 5000 | REST API server |
| Frontend  | 3000 | Next.js dev server |
| Database  | 5432 | PostgreSQL |
-->

## Key User Flows

<!-- TODO: Mô tả các luồng chính của hệ thống -->
<!-- Ví dụ:
1. User đăng ký → verify email → login → lấy JWT
2. User tạo record → backend validate → lưu DB → trả response
-->

## Environment Variables

<!-- TODO: Liệt kê các env vars cần thiết -->
<!-- Xem file .env.example để biết danh sách đầy đủ -->
