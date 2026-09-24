import type { ProblemDetails } from '@culinary/shared';

const BASE = (process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost/api') + '/v1';

/** Lỗi RFC 7807 trả về từ backend (common/filters/http-exception.filter). */
export class ApiError extends Error {
  constructor(readonly problem: ProblemDetails) {
    super(problem.detail ?? problem.title);
    this.name = 'ApiError';
  }

  /** Mã lỗi nghiệp vụ, vd AUTH_EMAIL_EXISTS (Phụ lục B của SRS). */
  get code() {
    return this.problem.detail;
  }

  /** Lỗi theo từng field để gắn vào form. */
  get fieldErrors() {
    return this.problem.errors ?? {};
  }
}

export interface ApiOptions extends Omit<RequestInit, 'body'> {
  body?: unknown;
  accessToken?: string | null;
}

/** Gọi API và bóc envelope `{ data, meta }`; lỗi ném ra dưới dạng ApiError. */
export async function api<T>(path: string, { body, accessToken, headers, ...init }: ApiOptions = {}): Promise<T> {
  const res = await fetch(BASE + path, {
    ...init,
    headers: {
      ...(body === undefined ? {} : { 'Content-Type': 'application/json' }),
      ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
      ...headers,
    },
    body: body === undefined ? undefined : JSON.stringify(body),
  });

  if (res.status === 204) return undefined as T;

  const payload = await res.json().catch(() => null);

  if (!res.ok) {
    throw new ApiError(
      (payload as ProblemDetails | null) ?? {
        type: 'about:blank',
        title: res.statusText || 'Request failed',
        status: res.status,
      },
    );
  }

  return (payload as { data: T }).data;
}
