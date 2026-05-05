# Frontend Development Rules

> Stack: Next.js 15 (App Router) + TypeScript + React Query + Zustand + auto-gen API types

## File Structure

```
frontend/src/
├── app/                    ← Pages & layouts (App Router)
│   ├── (auth)/             ← Route group: login, register
│   ├── (dashboard)/        ← Route group: kanban, projects
│   │   ├── board/          ← Kanban Board page
│   │   └── projects/       ← Projects page
│   ├── api/                ← Next.js API routes (nếu có BFF)
│   └── layout.tsx          ← Root layout
├── components/
│   ├── ui/                 ← Base UI: Button, Input, Badge...
│   ├── kanban/             ← KanbanBoard, TaskCard, Column
│   ├── task/               ← TaskForm, TaskDetail, TagBadge
│   └── agent/              ← AgentComment, HITLReviewCard
├── hooks/
│   ├── useTasks.ts         ← React Query hooks cho Tasks API
│   ├── useProjects.ts      ← React Query hooks cho Projects API
│   ├── useSSE.ts           ← SSE hook cho real-time NLP tags
│   └── usePrediction.ts    ← Hook gọi /api/predict
├── lib/
│   ├── api/                ← Auto-generated từ openapi.yaml (KHÔNG sửa tay)
│   └── api-client.ts       ← Base fetch wrapper
├── stores/
│   └── ui.store.ts         ← Zustand: UI state (modals, selected task)
└── types/                  ← TypeScript types (supplement auto-gen)
```

## API Client — Auto-generated từ OpenAPI (KHÔNG viết tay)

```bash
# Mỗi khi openapi.yaml thay đổi, chạy lại:
npx openapi-typescript-codegen --input ../openapi.yaml --output src/lib/api --client fetch

# Dùng:
import { TasksService } from "@/lib/api/services/TasksService";
const task = await TasksService.createTask({ title: "...", priority: 3 });
```

## React Query Pattern

```typescript
// hooks/useTasks.ts
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { TasksService } from "@/lib/api";

export function useTasks(projectId: string) {
  return useQuery({
    queryKey: ["tasks", projectId],
    queryFn: () => TasksService.getTasks(projectId),
    staleTime: 30_000,     // Cache 30s
  });
}

export function useCreateTask() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: TasksService.createTask,
    onSuccess: (_, vars) => {
      qc.invalidateQueries({ queryKey: ["tasks", vars.projectId] });
    },
  });
}
```

## SSE Hook — Real-time NLP Tagging

```typescript
// hooks/useSSE.ts
export function useTaskTagUpdates(taskId: string) {
  const qc = useQueryClient();

  useEffect(() => {
    const source = new EventSource(
      `${process.env.NEXT_PUBLIC_API_URL}/api/v1/tasks/${taskId}/tag-stream`
    );

    source.onmessage = (e) => {
      const tags: string[] = JSON.parse(e.data);
      // Optimistic update — không cần refetch toàn bộ list
      qc.setQueryData(["task", taskId], (old: Task) => ({ ...old, tags }));
    };

    return () => source.close();  // Cleanup quan trọng
  }, [taskId, qc]);
}
```

## SHAP Explanation Display

```typescript
// components/task/PredictionCard.tsx
interface PredictionCardProps {
  predictedHours: number;
  explanation: Record<string, string>;  // {"high_dependency": "+2.1h"}
}

export function PredictionCard({ predictedHours, explanation }: PredictionCardProps) {
  return (
    <div className="prediction-card">
      <p>Dự đoán: <strong>{predictedHours}h</strong></p>
      <ul>
        {Object.entries(explanation).map(([factor, impact]) => (
          <li key={factor}>
            <span className="factor">{factor}</span>
            <span className={impact.startsWith("+") ? "positive" : "negative"}>{impact}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## Rules — Áp Dụng Cho Mọi Component

- **Không gọi API trực tiếp trong component** — dùng custom hook hoặc React Query
- **Không hardcode URL** — dùng `process.env.NEXT_PUBLIC_API_URL`
- **Xử lý loading & error state** ở mọi async call — không để UI treo
- **Không dùng `any` trong TypeScript** — dùng auto-gen types từ OpenAPI
- **Accessibility:** Mọi button/input phải có `aria-label` hoặc visible label
- **SSE cleanup:** Luôn `return () => source.close()` trong useEffect
- **State phân chia rõ:** Server state → React Query | UI state → Zustand

## Self-Check

```
[ ] Không gọi fetch/axios trực tiếp trong component
[ ] API types dùng auto-generated từ openapi.yaml — không viết tay
[ ] Loading và error state được xử lý
[ ] SSE hook có cleanup (source.close())
[ ] Không có `any` type không cần thiết
[ ] Không có console.log debug
[ ] Không hardcode URL hay credentials
[ ] SHAP explanation hiển thị cùng prediction
```
