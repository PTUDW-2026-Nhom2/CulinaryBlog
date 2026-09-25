/**
 * Client gọi REST API backend.
 *
 * - `NEXT_PUBLIC_API_URL` (vd `http://localhost/api`) không chứa `/v1`, version được
 *   nối ở đây để trùng prefix `api/v1` khai báo trong `main.ts` của backend.
 * - Server Component chạy trong container không đi qua `localhost` được, nên cho phép
 *   `API_URL` override riêng cho phía server (vd `http://nginx/api`).
 * - Envelope `{ data, meta }` (interceptor global) chưa được hiện thực ở backend nên
 *   `unwrap` chấp nhận cả body thô; khi interceptor lên thì chỗ này không phải sửa.
 */
const baseUrl = `${(process.env.API_URL ?? process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost/api').replace(/\/+$/, '')}/v1`;

function unwrap<T>(body: unknown): T {
  return body && typeof body === 'object' && 'data' in body
    ? ((body as { data: T }).data)
    : (body as T);
}

export async function apiGet<T>(
  path: string,
  params?: Record<string, string | number | undefined>,
  init?: RequestInit,
): Promise<T> {
  const url = new URL(`${baseUrl}${path}`);
  for (const [key, value] of Object.entries(params ?? {})) {
    if (value !== undefined) url.searchParams.set(key, String(value));
  }

  const res = await fetch(url, {
    ...init,
    headers: { Accept: 'application/json', ...init?.headers },
  });
  if (!res.ok) {
    throw new Error(`GET ${path} thất bại: ${res.status} ${res.statusText}`);
  }
  return unwrap<T>(await res.json());
}
