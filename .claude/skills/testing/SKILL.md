# Testing Rules

## Vòng Đời File Test

```
TẠO  → Chỉ tạo khi cần test thật (không tạo file test rỗng)
DÙNG → Test phải chạy được: npm test
XÓA  → Xóa mock/seed file sau khi dùng xong
```

## Naming Convention

```
src/services/user.service.ts
         ↓ test file phải ở cùng vị trí  
src/services/user.service.test.ts
```

## Mock Data Rules

- Mock data chỉ tồn tại trong test file — KHÔNG tạo file mock riêng production
- Factory functions thay vì hardcode objects
- `afterEach` cleanup để test không ảnh hưởng nhau

## Self-Check Trước Commit

```
[ ] Không còn file *.test.ts tạm thời ở nơi không hợp lệ
[ ] Không còn file seed/mock rời rạc
[ ] Tất cả test có thể chạy độc lập (không phụ thuộc nhau)
[ ] Không có test bị skip mà không có lý do
```
