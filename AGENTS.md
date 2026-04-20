# {{PROJECT_NAME}} — AI Agent Context

> **Entry point duy nhất cho AI context.**  
> Đọc section này trước, sau đó đọc SKILL.md tương ứng với task.

## Skills Directory

| Khi làm việc với... | Đọc skill file này |
|--------------------|-------------------|
| Kiến trúc tổng thể, stack, luồng hệ thống | `.claude/skills/architecture/SKILL.md` |
| Backend (`{{BACKEND_DIR}}/src/**`) | `.claude/skills/backend/SKILL.md` |
| Frontend Web (`{{FRONTEND_DIR}}/src/**`) | `.claude/skills/frontend/SKILL.md` |
| Tạo file test, mock data, cleanup | `.claude/skills/testing/SKILL.md` |
| Git commit, workflow | `.claude/skills/git-workflow/SKILL.md` |

## Templates Directory

> Khi tạo Service/Controller/Route **mới**, PHẢI copy từ template và thay thế placeholder.

| Khi tạo... | Dùng template này |
|-----------|------------------|
| Service mới | `.claude/templates/service.template.ts` |
| Controller mới | `.claude/templates/controller.template.ts` |
| Route file mới | `.claude/templates/routes.template.ts` |

**Quy trình tạo feature mới:**
```
1. Copy service.template.ts   → src/services/<tên>.service.ts
2. Copy controller.template.ts → src/controllers/<tên>.controller.ts
3. Copy routes.template.ts    → src/routes/<tên>.routes.ts
4. Tìm-Thay "Example"/"example" → tên feature của bạn
5. Đăng ký route trong index.ts
6. Xóa các comment hướng dẫn
```

## Hard Limits — Giới Hạn Cứng Cho AI

> Những giới hạn này ngăn AI "làm quá tay" — đập cả một file chỉ để sửa 1 dòng.
> Đây là văn hóa "Small PR" của Google/Meta áp dụng cho AI agent.

### Giới hạn thay đổi mỗi lần

| Loại task | Tối đa dòng thay đổi | Tối đa commit |
|-----------|:--------------------:|:-------------:|
| Bug fix | 50 dòng | 1 commit |
| Refactor | 150 dòng | 1 commit |
| Feature mới | 300 dòng | Chia nhỏ |

### Giới hạn kích thước file

- **Tối đa 400 dòng/file.** Nếu file sắp vượt → tách logic ra file mới trước khi thêm.
- **Không viết function dài hơn 50 dòng.** Dài hơn → phải extract ra hàm con.

### Quy tắc xác nhận

```
AI KHÔNG ĐƯỢC báo "xong" nếu chưa:
  1. Chạy lệnh verify (tsc --noEmit, npm test, npm run build)
  2. Dán output thực tế của lệnh đó vào chat
  3. Nếu output có lỗi → phải fix xong, không được bỏ qua
```

---

## ADR — Khi Nào Phải Tạo

> Template: `docs/adr/ADR-000-template.md` — Copy, đặt số tiếp theo, điền vào.

AI **BẮT BUỘC đề xuất tạo ADR mới** khi:

| Tình huống | Ví dụ |
|-----------|-------|
| Chọn thư viện/framework mới | Thêm `zod`, đổi từ `axios` sang `fetch` |
| Thay đổi kiến trúc có phạm vi lớn | Thêm cache layer, tách microservice |
| Quyết định trade-off rõ ràng | Chọn eventual consistency thay vì strong consistency |
| Từ chối một cách tiếp cận | "Không dùng X vì Y" cũng cần ghi lại |

AI **KHÔNG cần tạo ADR** cho: bug fix, refactor nhỏ, thêm field, thay đổi UI/style.

**Quy trình khi AI gặp tình huống cần ADR:**
```
1. Thông báo: "Quyết định này nên được ghi vào ADR"
2. Đề xuất nội dung ADR (context, options, decision, consequences)
3. Tạo file: docs/adr/ADR-00N-ten-ngan.md
4. Nhắc commit cùng với code thay đổi
```

## Memory System — Duy Trì Context Giữa Các Buổi Làm Việc

> LLM mất trí nhớ sau mỗi session. Memory System giải quyết vấn đề này.
> Không cần tool phức tạp — chỉ cần 2 file markdown.

### Cấu trúc

```
docs/
├── MEMORY.md              ← Index tổng hợp mọi quyết định đã ghi nhớ
└── retros/
    └── YYYY-MM-DD-topic.md ← Nhật ký sau mỗi buổi làm việc quan trọng
```

### Quy tắc viết Retro

Sau bất kỳ buổi làm việc nào có **thay đổi kiến trúc, fix bug khó, hoặc cài thư viện mới**, AI PHẢI tạo file retro với nội dung:

```markdown
## [YYYY-MM-DD] [Tên ngắn gọn của task]

### Đã làm
- Gạch đầu dòng những gì đã hoàn thành

### Vấn đề gặp phải & cách giải quyết
- Ghi rõ để buổi sau không mò lại từ đầu

### Còn dang dở
- Task nào chưa xong, blocker là gì

### Phải nhớ buổi sau
- Các quyết định kỹ thuật quan trọng cần nhớ
```

### Bắt đầu buổi làm việc mới

```
Bước đầu tiên của MỌI buổi làm việc:
  1. Đọc file retro gần nhất trong docs/retros/
  2. Đọc MEMORY.md để biết các quyết định đã chốt
  3. Chỉ sau đó mới bắt đầu code
```

---

## Self-Check Trước Khi Kết Thúc Task

```
IMPACT ANALYSIS
[ ] Đã chạy impact analysis trước khi sửa BẤT KỲ hàm cũ nào
[ ] Tất cả callers trực tiếp đã được cập nhật đồng bộ
[ ] Nếu Risk = HIGH/CRITICAL → đã báo cáo cho user trước khi sửa

CODE QUALITY
[ ] Đã đọc SKILL.md tương ứng với task
[ ] Không có file test/mock/seed còn sót lại
[ ] Không có console.log debug trong production code
[ ] Không có hardcoded secrets
[ ] Không có import unused

ARCHITECTURE
[ ] Response format đúng chuẩn { success, data?, message?, errorCode? }
[ ] Controller không chứa business logic
[ ] Protected routes có authMiddleware

TEMPLATES & ADR
[ ] Nếu tạo Service/Controller/Route mới → đã dùng template từ .claude/templates/
[ ] Nếu có quyết định kiến trúc mới → đã tạo hoặc đề xuất ADR tương ứng

HARD LIMITS
[ ] Số dòng thay đổi không vượt giới hạn (bug≤50, feature≤300)
[ ] Không có file nào vượt 400 dòng sau khi chỉnh sửa
[ ] Đã chạy lệnh verify và paste output thực tế vào chat

MEMORY SYSTEM
[ ] Nếu buổi làm việc quan trọng → đã tạo retro trong docs/retros/
[ ] Nếu có quyết định kỹ thuật mới → đã cập nhật MEMORY.md
```
