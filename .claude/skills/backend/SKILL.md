# Backend Development Rules

> Stack: <!-- TODO: Điền stack thực tế, e.g. FastAPI+Python | Node.js+Express | Go | Laravel -->

## ⛔ Impact Analysis — Nguyên Tắc Dò Mìn (BẮT BUỘC)

Trước khi sửa BẤT KỲ function/class có sẵn nào:

```
Bước 1: Tìm tất cả nơi đang gọi function/class đó
        → grep -r "function_name" src/   (hoặc tool search của IDE)
Bước 2: Đánh giá blast radius
        → d=1 (WILL BREAK): caller trực tiếp — PHẢI cập nhật đồng thời
        → d=2 (LIKELY AFFECTED): caller gián tiếp — Nên test
Bước 3: Nếu có nhiều d=1 callers → báo user TRƯỚC khi sửa
Bước 4: Sửa function + cập nhật TẤT CẢ d=1 callers trong cùng commit
```

## Architecture Pattern

```
<!-- TODO: Điền pattern phù hợp với stack của bạn -->

Ví dụ phổ biến:
  MVC:        Request → Router → Controller → Service → Model → DB
  Clean Arch: Request → Controller → Use Case → Repository → DB
  Hexagonal:  Request → Port → Adapter → Domain → Port → DB
```

- **Router/Controller**: Chỉ xử lý HTTP — nhận request, gọi service, trả response. KHÔNG có business logic.
- **Service/Use Case**: Toàn bộ business logic. KHÔNG import HTTP framework objects.
- **Repository/Data Layer**: Database access. Chỉ lấy fields cần thiết (chống data leak).

## Standard Response Format

```
<!-- TODO: Định nghĩa response format chuẩn cho project -->

Ví dụ:
  Success: { success: true, data: T, message?: string }
  Error:   { success: false, message: string, errorCode?: string }
```

## Error Handling

```
<!-- TODO: Quy tắc xử lý lỗi theo stack của bạn -->

Nguyên tắc chung:
  - Mọi async operation phải có error handling
  - Không expose stack trace ra client
  - Log đầy đủ context ở server (không log sensitive data)
  - Trả về HTTP status code phù hợp (400/401/403/404/422/500)
```

## Security Rules (Universal)

- **Chống IDOR:** Mọi resource query phải filter theo owner ID — không tin dữ liệu từ client
- **Auth on routes:** Mọi protected route phải có auth middleware/guard
- **Input validation:** Validate và sanitize input trước khi xử lý hoặc query DB
- **No sensitive log:** KHÔNG log password, token, secret, PII
- **No hardcoded secrets:** Dùng biến môi trường

## Data Access Rules

```
<!-- TODO: Điền rules cụ thể theo ORM/DB của bạn -->

Nguyên tắc chung:
  - Chỉ select fields cần thiết (không select *)
  - Luôn có LIMIT khi query list (tránh full table scan)
  - Index cho các cột thường dùng trong WHERE/ORDER BY
  - Dùng prepared statements / parameterized queries (chống SQL injection)
```

## Self-Check

```
[ ] Controller/Router không chứa business logic
[ ] Mọi async operation có error handling
[ ] Data query chỉ lấy fields cần thiết
[ ] Filter theo owner ID cho user-owned resources (chống IDOR)
[ ] Không có debug log trong production code
[ ] Không có hardcoded secrets
[ ] Input được validate trước khi xử lý
[ ] Protected routes có auth guard/middleware
```

<!-- TODO: Thêm rules đặc thù cho stack (ORM patterns, DB session management, v.v.) -->
