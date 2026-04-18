# Frontend Development Rules

> Stack: <!-- TODO: Next.js 14 App Router + TypeScript + TailwindCSS -->

## File Structure (App Router)

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

## API Client Pattern

```typescript
// lib/api.ts — tập trung tất cả API calls vào đây
const API_BASE = process.env.NEXT_PUBLIC_API_URL;

export async function apiGet<T>(path: string): Promise<T> {
  const res = await fetch(`${API_BASE}${path}`, {
    headers: { Authorization: `Bearer ${getToken()}` },
  });
  if (!res.ok) throw new Error(await res.text());
  return res.json();
}
```

## Rules

- Server Components mặc định — chỉ dùng `'use client'` khi thực sự cần
- Không gọi API trực tiếp trong component — dùng custom hook hoặc lib/api.ts
- Loading state và error state phải được xử lý
- KHÔNG hardcode URL — dùng `process.env.NEXT_PUBLIC_*`

<!-- TODO: Thêm rules specific cho project (component library, state management, etc.) -->
