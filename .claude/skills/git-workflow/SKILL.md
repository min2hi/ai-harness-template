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

**Types:** `feat` | `fix` | `refactor` | `chore` | `docs` | `test` | `perf` | `style` | `ci` | `revert`

**Ví dụ:**
```bash
feat(auth): add refresh token endpoint
fix(api): handle null response from payment service
docs(adr): add ADR-004 why we chose redis for caching
chore(deps): update prisma to 5.14.0
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
