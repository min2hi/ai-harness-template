# {{PROJECT_NAME}} — AI Agent Context

> **Entry point duy nhất cho AI context.**
> Đọc section này trước, sau đó đọc SKILL.md tương ứng với task.

---

## 🚀 ONBOARDING — Đọc nếu đây là lần đầu dùng template này

> **Dành cho AI:** Nếu các file SKILL.md còn chứa `<!-- TODO -->`, hãy hỏi user các câu hỏi dưới đây TRƯỚC KHI làm bất kỳ task nào khác.

### Câu hỏi AI phải hỏi khi setup lần đầu

```
1. PROJECT_NAME là gì? (tên dự án)
2. Tech stack Backend là gì? (Node.js/Express | FastAPI/Python | Django | Laravel | Go | Rust | ...)
3. Tech stack Frontend là gì? (Next.js | React+Vite | Vue | Nuxt | Flutter Web | không có | ...)
4. Database & ORM dùng gì? (PostgreSQL+Prisma | MySQL+TypeORM | MongoDB | SQLite | ...)
5. Authentication: JWT | Session | OAuth | Firebase Auth | Supabase Auth | ...
6. Dự án có ML/AI không? (có → hỏi thêm: framework nào? | không)
7. Dự án có LLM Agent không? (có → hỏi thêm: LangChain | LlamaIndex | custom | không)
8. Có background jobs không? (Celery | BullMQ | Sidekiq | Cloud Functions | không)
9. Deployment target: Docker | Vercel | Railway | AWS | GCP | Azure | ...
10. Có mobile app không? (Flutter | React Native | Swift | Kotlin | không)
```

Sau khi có đủ thông tin → điền vào `architecture/SKILL.md` và các skill files liên quan.

---

## Skills Directory

| Khi làm việc với... | Đọc skill file này |
|--------------------|-------------------|
| Kiến trúc tổng thể, stack, ports, luồng hệ thống | `.claude/skills/architecture/SKILL.md` |
| Backend (`{{BACKEND_DIR}}/src/**`) | `.claude/skills/backend/SKILL.md` |
| Frontend (`{{FRONTEND_DIR}}/src/**`) | `.claude/skills/frontend/SKILL.md` |
| ML Pipeline (nếu có) | `.claude/skills/ml/SKILL.md` |
| Agent & LLM (nếu có) | `.claude/skills/agent/SKILL.md` |
| Tạo file test, mock data, fixtures | `.claude/skills/testing/SKILL.md` |
| Git commit, versioning, workflow | `.claude/skills/git-workflow/SKILL.md` |

## Templates Directory

> Khi tạo module **mới**, PHẢI copy từ template và thay thế placeholder.

| Khi tạo... | Dùng template này |
|-----------|------------------|
| TypeScript Service mới | `.claude/templates/service.template.ts` |
| TypeScript Controller mới | `.claude/templates/controller.template.ts` |
| TypeScript Route file mới | `.claude/templates/routes.template.ts` |
| Python Service mới | `.claude/templates/service.template.py` |
| Python Router mới | `.claude/templates/router.template.py` |
| SQLAlchemy Model mới | `.claude/templates/model.template.py` |
| Pydantic Schema mới | `.claude/templates/schema.template.py` |
| Celery Task mới | `.claude/templates/celery_task.template.py` |

**Quy trình tạo feature mới:**
```
1. Copy template phù hợp
2. Tìm-Thay {{RESOURCE_NAME}} → tên feature của bạn
3. Implement theo patterns trong SKILL.md tương ứng
4. Tạo migration nếu schema thay đổi
5. Viết test
6. Xóa các comment hướng dẫn
```

## Hard Limits — Giới Hạn Cứng Cho AI

| Loại task | Tối đa dòng thay đổi | Tối đa commit |
|-----------|:--------------------:|:-------------:|
| Bug fix | 50 dòng | 1 commit |
| Refactor | 150 dòng | 1 commit |
| Feature mới | 300 dòng | Chia nhỏ |

- **Tối đa 400 dòng/file.** Nếu file sắp vượt → tách logic ra file mới trước khi thêm.
- **Không viết function dài hơn 50 dòng.** Dài hơn → phải extract ra hàm con.

### Quy tắc xác nhận

```
AI KHÔNG ĐƯỢC báo "xong" nếu chưa:
  1. Chạy lệnh verify phù hợp với stack (test, build, type-check...)
  2. Dán output thực tế của lệnh đó vào chat
  3. Nếu output có lỗi → phải fix xong, không được bỏ qua
```

## ADR — Khi Nào Phải Tạo

> Template: `docs/adr/ADR-000-template.md`

AI **BẮT BUỘC đề xuất tạo ADR mới** khi:

| Tình huống | Ví dụ |
|-----------|-------|
| Chọn thư viện/framework mới | Thêm thư viện X, đổi từ A sang B |
| Thay đổi kiến trúc có phạm vi lớn | Tách microservice, thêm cache layer |
| Quyết định trade-off rõ ràng | Chọn eventual consistency thay vì strong consistency |
| Từ chối một cách tiếp cận | "Không dùng X vì Y" |

AI **KHÔNG cần tạo ADR** cho: bug fix, refactor nhỏ, thêm field, thay đổi UI/style, bump version.

## Memory System

```
docs/
├── MEMORY.md              ← Index tổng hợp mọi quyết định đã ghi nhớ
└── retros/
    └── YYYY-MM-DD-topic.md ← Nhật ký sau mỗi buổi làm việc quan trọng
```

**Bắt đầu buổi làm việc mới:**
```
1. Đọc file retro gần nhất trong docs/retros/
2. Đọc MEMORY.md để biết các quyết định đã chốt
3. Chỉ sau đó mới bắt đầu code
```

## Self-Check Trước Khi Kết Thúc Task

```
IMPACT ANALYSIS
[ ] Đã chạy impact analysis (grep/search) trước khi sửa BẤT KỲ hàm cũ nào
[ ] Tất cả d=1 callers đã được cập nhật đồng thời

CODE QUALITY
[ ] Đã đọc SKILL.md tương ứng với task
[ ] Không có file test/mock/seed còn sót lại trong production code
[ ] Không có debug log trong production code
[ ] Không có hardcoded secrets
[ ] Không có unused imports

BACKEND
[ ] Response format đúng chuẩn đã định nghĩa trong backend/SKILL.md
[ ] Service/Use Case không chứa HTTP layer imports
[ ] Mọi resource được filter đúng theo ownership (chống IDOR)
[ ] DB session/connection được quản lý đúng pattern
[ ] Protected routes có auth middleware/guard
[ ] Migration đã tạo nếu schema thay đổi

ML / AGENT (nếu có)
[ ] Feature extraction dùng chung cho train và serve
[ ] LLM call có cost/budget check trước khi thực thi
[ ] Agent output qua validator trước khi lưu
[ ] Tool/function có allowlist/sandbox

TEMPLATES & ADR
[ ] Nếu tạo module mới → đã dùng template
[ ] Nếu có quyết định kiến trúc mới → đã tạo hoặc đề xuất ADR

HARD LIMITS
[ ] Số dòng thay đổi không vượt giới hạn
[ ] Không có file nào vượt 400 dòng sau khi chỉnh sửa
[ ] Đã chạy lệnh verify và paste output thực tế vào chat

MEMORY SYSTEM
[ ] Nếu buổi làm việc quan trọng → đã tạo retro trong docs/retros/
[ ] Nếu có quyết định kỹ thuật mới → đã cập nhật MEMORY.md
```
