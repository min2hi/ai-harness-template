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
```
