'use client';

import { useState } from 'react';
import { CheckCircle2 } from 'lucide-react';
import { ApiError } from '@/lib/api-client';
import { useAuth } from '@/lib/auth';
import { initialsOf } from '@/lib/utils';

export function ProfileForm() {
  const { user, updateProfile } = useAuth();
  // RequireRole chỉ render form khi đã có user nên khởi tạo thẳng từ user
  const [name, setName] = useState(user?.displayName ?? '');
  const [avatar, setAvatar] = useState(user?.avatarUrl ?? '');
  const [bio, setBio] = useState(user?.bio ?? '');
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setBusy(true);
    try {
      await updateProfile({ displayName: name.trim(), avatarUrl: avatar.trim(), bio });
      setSaved(true);
      setTimeout(() => setSaved(false), 2600);
    } catch (err) {
      setError(err instanceof ApiError ? err.problem.title : 'Không lưu được, thử lại sau.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6">
      <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">Tài khoản</p>
      <h1 className="mt-2 font-display text-3xl sm:text-4xl">Trang cá nhân</h1>

      <div className="mt-8 flex flex-wrap items-center gap-5 rounded-2xl border border-border bg-card p-6 shadow-card">
        {avatar ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={avatar}
            alt={`Ảnh đại diện của ${name}`}
            className="h-20 w-20 rounded-full object-cover"
            onError={(e) => (e.currentTarget.style.display = 'none')}
          />
        ) : (
          <span className="grid h-20 w-20 place-items-center rounded-full bg-primary-soft font-display text-xl font-semibold">
            {initialsOf(name)}
          </span>
        )}
        <div className="min-w-0">
          <p className="font-display text-xl">{name || 'Người nấu ẩn danh'}</p>
          <p className="text-sm text-muted-foreground">{user?.email}</p>
          <p className="mt-2 inline-flex rounded-full bg-accent-soft px-3 py-1 text-xs font-semibold uppercase tracking-wide text-accent">
            {user?.role}
          </p>
        </div>
      </div>

      {saved && (
        <div className="mt-6 flex items-center gap-2 rounded-xl border border-accent/30 bg-accent-soft px-4 py-3 text-sm text-accent">
          <CheckCircle2 className="h-4 w-4" />
          Đã cập nhật hồ sơ.
        </div>
      )}

      <form className="mt-6 space-y-5 rounded-2xl border border-border bg-card p-6 shadow-card sm:p-8" onSubmit={submit}>
        <h2 className="font-display text-xl">Chỉnh sửa thông tin</h2>
        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Tên hiển thị</span>
          <input className="field" value={name} onChange={(e) => setName(e.target.value)} />
        </label>
        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Ảnh đại diện (URL)</span>
          <input
            className="field"
            value={avatar}
            placeholder="https://example.com/photo.jpg"
            onChange={(e) => setAvatar(e.target.value)}
          />
        </label>
        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Giới thiệu ngắn</span>
          <textarea rows={3} className="field resize-y" value={bio} onChange={(e) => setBio(e.target.value)} />
        </label>

        {error && <p className="text-sm text-destructive">{error}</p>}

        <button
          type="submit"
          disabled={busy}
          className="rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-60"
        >
          {busy ? 'Đang lưu…' : 'Lưu thay đổi'}
        </button>
      </form>
    </div>
  );
}
