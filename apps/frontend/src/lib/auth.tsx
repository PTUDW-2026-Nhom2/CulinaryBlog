'use client';

import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState } from 'react';
import type { AuthResponseDto, UserProfileDto } from '@culinary/shared';
import { api, ApiError } from './api-client';

// ponytail: token nằm ở localStorage cho đơn giản (SRS yêu cầu refresh token đi trong body,
// không dùng cookie nên không có CSRF). Muốn chống XSS chặt hơn thì chuyển access token vào memory.
const STORAGE_KEY = 'culinary.auth';

interface Session {
  accessToken: string;
  refreshToken: string;
  /** epoch ms hết hạn của access token */
  expiresAt: number;
}

interface AuthContextValue {
  user: UserProfileDto | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (displayName: string, email: string, password: string) => Promise<void>;
  loginWithGoogle: (idToken: string) => Promise<void>;
  logout: () => Promise<void>;
  updateProfile: (patch: Partial<Pick<UserProfileDto, 'displayName' | 'avatarUrl' | 'bio'>>) => Promise<void>;
  /** Access token còn hạn, tự refresh nếu cần. */
  getAccessToken: () => Promise<string | null>;
}

const AuthContext = createContext<AuthContextValue | null>(null);

function readSession(): Session | null {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? (JSON.parse(raw) as Session) : null;
  } catch {
    return null;
  }
}

function toSession(res: AuthResponseDto): Session {
  return {
    accessToken: res.accessToken,
    refreshToken: res.refreshToken,
    expiresAt: Date.now() + res.expiresIn * 1000,
  };
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<UserProfileDto | null>(null);
  const [loading, setLoading] = useState(true);
  const session = useRef<Session | null>(null);
  const refreshing = useRef<Promise<string | null> | null>(null);

  const save = useCallback((next: Session | null) => {
    session.current = next;
    if (next) localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
    else localStorage.removeItem(STORAGE_KEY);
  }, []);

  const clear = useCallback(() => {
    save(null);
    setUser(null);
  }, [save]);

  /** Đổi refresh token lấy cặp token mới; gọi song song chỉ chạy 1 lần. */
  const refresh = useCallback(async (): Promise<string | null> => {
    const current = session.current;
    if (!current) return null;
    if (refreshing.current) return refreshing.current;

    refreshing.current = api<AuthResponseDto>('/auth/refresh', {
      method: 'POST',
      body: { refreshToken: current.refreshToken },
    })
      .then((res) => {
        save(toSession(res));
        if (res.user) setUser(res.user);
        return res.accessToken;
      })
      .catch((err) => {
        // AUTH_REFRESH_TOKEN_EXPIRED / _REVOKED -> buộc đăng nhập lại
        if (err instanceof ApiError && err.problem.status === 401) clear();
        return null;
      })
      .finally(() => {
        refreshing.current = null;
      });

    return refreshing.current;
  }, [clear, save]);

  const getAccessToken = useCallback(async () => {
    const current = session.current;
    if (!current) return null;
    // refresh sớm 30s để tránh hết hạn giữa chừng
    if (current.expiresAt - 30_000 > Date.now()) return current.accessToken;
    return refresh();
  }, [refresh]);

  const loadMe = useCallback(async () => {
    const token = await getAccessToken();
    if (!token) {
      setUser(null);
      return;
    }
    try {
      setUser(await api<UserProfileDto>('/auth/me', { accessToken: token }));
    } catch (err) {
      if (err instanceof ApiError && err.problem.status === 401) clear();
    }
  }, [clear, getAccessToken]);

  useEffect(() => {
    session.current = readSession();
    // localStorage chỉ đọc được ở client nên phải bootstrap trong effect; setState nằm
    // trong callback bất đồng bộ, không gây cascading render.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    void loadMe().finally(() => setLoading(false));
  }, [loadMe]);

  const afterAuth = useCallback(
    (res: AuthResponseDto) => {
      save(toSession(res));
      if (res.user) setUser(res.user);
      else void loadMe();
    },
    [loadMe, save],
  );

  const value = useMemo<AuthContextValue>(
    () => ({
      user,
      loading,
      getAccessToken,
      login: async (email, password) => {
        afterAuth(await api<AuthResponseDto>('/auth/login', { method: 'POST', body: { email, password } }));
      },
      register: async (displayName, email, password) => {
        await api('/auth/register', { method: 'POST', body: { email, password, displayName } });
        afterAuth(await api<AuthResponseDto>('/auth/login', { method: 'POST', body: { email, password } }));
      },
      loginWithGoogle: async (idToken) => {
        afterAuth(await api<AuthResponseDto>('/auth/google', { method: 'POST', body: { idToken } }));
      },
      logout: async () => {
        const current = session.current;
        const token = await getAccessToken();
        try {
          if (current && token) {
            await api('/auth/logout', {
              method: 'POST',
              accessToken: token,
              body: { refreshToken: current.refreshToken },
            });
          }
        } finally {
          clear();
        }
      },
      updateProfile: async (patch) => {
        const token = await getAccessToken();
        if (!token) throw new Error('Chưa đăng nhập');
        setUser(await api<UserProfileDto>('/auth/me', { method: 'PATCH', accessToken: token, body: patch }));
      },
    }),
    [afterAuth, clear, getAccessToken, loading, user],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth phải nằm trong <AuthProvider>');
  return ctx;
}
