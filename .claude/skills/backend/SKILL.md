# Backend Development Rules

> Stack: <!-- TODO: Điền stack thực tế, ví dụ: Node.js + Express + TypeScript + Prisma | NestJS | FastAPI | Django -->

## ⛔ Impact Analysis — Nguyên Tắc Dò Mìn (BẮT BUỘC)

Trước khi sửa BẤT KỲ hàm/biến có sẵn nào:

```
Bước 1: Tìm tất cả nơi đang gọi hàm/biến đó
        → grep -r "functionName" src/
Bước 2: Đánh giá blast radius
        → d=1 (WILL BREAK): caller trực tiếp — PHẢI cập nhật
        → d=2 (LIKELY AFFECTED): caller gián tiếp — Nên test
Bước 3: Nếu có nhiều d=1 caller → báo user trước khi sửa
Bước 4: Sửa function + cập nhật TẤT CẢ d=1 callers đồng thời
```

## Architecture Pattern

```
Request → Route → Middleware → Controller → Service → Data Layer → DB
```

- **Route**: Chỉ định nghĩa endpoint và middleware, không có logic
- **Controller**: Nhận request, gọi Service, trả response — **KHÔNG** có business logic
- **Service**: Toàn bộ business logic — **KHÔNG** import `Request`/`Response`
- **Data Layer** (Prisma/TypeORM/Mongoose/v.v.): Data access — dùng `select`/`projection` để tránh data leak

## Standard Response Format

```typescript
// Success
{ success: true, data: T, message?: string }

// Error
{ success: false, message: string, errorCode?: string }
```

## Error Handling

```typescript
// Controller — mọi method đều có try/catch
async create(req: Request, res: Response) {
  try {
    const result = await this.service.create(req.user.id, req.body);
    res.status(201).json({ success: true, data: result });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Lỗi không xác định';
    res.status(400).json({ success: false, message });
  }
}
```

## Data Access Rules

```typescript
// ✅ ĐÚNG — select chỉ lấy field cần thiết (Prisma example)
const user = await prisma.user.findUnique({
  where: { id },
  select: { id: true, name: true, email: true }
});

// ❌ SAI — không bao giờ trả về toàn bộ object (có thể leak password/secret)
const user = await prisma.user.findUnique({ where: { id } });
```

> Nguyên tắc này áp dụng cho mọi ORM: dùng `select` (Prisma), `projection` (Mongoose), `columns` (TypeORM) để chỉ lấy field cần thiết.

## Security Rules

- Mọi CRUD phải filter theo `userId` (chống IDOR — Insecure Direct Object Reference)
- Protected routes phải có `authMiddleware` (hoặc guard tương đương)
- **KHÔNG** log sensitive data (password, token, PII)
- **KHÔNG** hardcode secrets — dùng biến môi trường (`process.env.*`)
- Validate và sanitize input trước khi xử lý

## Self-Check

```
[ ] Controller không chứa business logic
[ ] Mọi async method có try/catch
[ ] Data query dùng select/projection
[ ] Filter theo userId cho user-owned resources
[ ] Không có console.log debug
[ ] Không có hardcoded secrets
[ ] Input được validate trước khi query DB
```
