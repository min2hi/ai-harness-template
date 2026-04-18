# Backend Development Rules

> Stack: <!-- TODO: Node.js + Express + TypeScript + Prisma -->

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
Request → Route → Middleware → Controller → Service → Prisma → DB
```

- **Route**: Chỉ định nghĩa endpoint và middleware
- **Controller**: Nhận request, gọi Service, trả response — KHÔNG có business logic
- **Service**: Toàn bộ business logic — KHÔNG import Request/Response
- **Prisma**: Data access — LUÔN dùng `select` để tránh data leak

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
    const result = await this.service.create(req.userId, req.body);
    res.status(201).json({ success: true, data: result });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
}
```

## Prisma Rules

```typescript
// ✅ ĐÚNG — select chỉ lấy field cần thiết
const user = await prisma.user.findUnique({
  where: { id },
  select: { id: true, name: true, email: true }
});

// ❌ SAI — không bao giờ trả về toàn bộ object (có thể leak password)
const user = await prisma.user.findUnique({ where: { id } });
```

## Security Rules

- Mọi CRUD phải filter theo `userId` (chống IDOR)
- Protected routes phải có `authMiddleware`
- KHÔNG log sensitive data (password, token, PII)
- KHÔNG hardcode secrets — dùng `process.env`

## Self-Check

```
[ ] Controller không chứa business logic
[ ] Mọi method có try/catch
[ ] Prisma query dùng select
[ ] Filter theo userId cho user-owned resources
[ ] Không có console.log debug
[ ] Không có hardcoded secrets
```
