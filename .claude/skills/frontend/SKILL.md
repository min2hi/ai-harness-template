# Frontend Development Rules

> Stack: <!-- TODO: Điền stack thực tế, ví dụ: Next.js 14 App Router + TypeScript + TailwindCSS | React + Vite | Flutter Web -->

## File Structure

<!-- TODO: Điền cấu trúc thư mục thực tế của project -->
<!-- Ví dụ cho Next.js App Router:
```
src/
├── app/               ← Pages và layouts (App Router)
│   ├── (auth)/        ← Route groups
│   ├── api/           ← API routes (nếu có BFF)
│   └── layout.tsx     ← Root layout
├── components/        ← Shared UI components
├── lib/               ← Utilities, API client, helpers
├── hooks/             ← Custom React hooks
└── types/             ← TypeScript type definitions
```
-->

## API Client Pattern

```typescript
// lib/api.ts — tập trung tất cả API calls vào đây
const API_BASE = process.env.NEXT_PUBLIC_API_URL; // hoặc import.meta.env.VITE_API_URL

export async function apiGet<T>(path: string): Promise<T> {
  const res = await fetch(`${API_BASE}${path}`, {
    headers: { Authorization: `Bearer ${getToken()}` },
  });
  if (!res.ok) throw new Error(await res.text());
  return res.json();
}
```

## Rules — Áp Dụng Cho Mọi Frontend Stack

- **Tách biệt concerns:** Không gọi API trực tiếp trong component UI — dùng custom hook, service layer, hoặc state management.
- **Không hardcode URL:** Dùng biến môi trường (`process.env.*` / `import.meta.env.*`).
- **Xử lý loading & error state** ở mọi async call — không để UI treo không phản hồi.
- **KHÔNG dùng `any` trong TypeScript** — khai báo interface/type rõ ràng.
- **Tối ưu re-render:** Tránh tạo object/array mới trong JSX render; dùng `useMemo`/`useCallback` khi cần.
- **Accessibility:** Mọi button/input phải có `aria-label` hoặc visible label.

## Self-Check

```
[ ] Không gọi API trực tiếp trong component
[ ] Không hardcode URL hay credentials
[ ] Loading state và error state đã được xử lý
[ ] Không có `any` type không cần thiết
[ ] Không có console.log debug
```

<!-- TODO: Thêm rules đặc thù cho project (component library, state management, routing) -->
