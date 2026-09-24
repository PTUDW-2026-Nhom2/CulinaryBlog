'use client';

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import {
  ChefHat,
  Search,
  Menu,
  X,
  PenLine,
  User,
  BookMarked,
  LogOut,
  LayoutDashboard,
  Tags,
  LogIn,
} from 'lucide-react';
import { useState, type ReactNode } from 'react';
import { useAuth } from '@/lib/auth';
import { cn, initialsOf } from '@/lib/utils';

const links = [
  { to: '/', label: 'Trang chủ' },
  { to: '/recipes', label: 'Công thức' },
  { to: '/categories', label: 'Danh mục' },
];

export function Navbar() {
  const [open, setOpen] = useState(false);
  const [menu, setMenu] = useState(false);
  const [query, setQuery] = useState('');
  const router = useRouter();
  const pathname = usePathname();
  const { user, logout } = useAuth();

  const isActive = (to: string) => (to === '/' ? pathname === '/' : pathname.startsWith(to));

  const submitSearch = (e: React.FormEvent) => {
    e.preventDefault();
    setOpen(false);
    router.push(query ? `/search?q=${encodeURIComponent(query)}` : '/search');
  };

  const navClass = (to: string) =>
    cn(
      'rounded-full px-4 py-2 text-sm font-medium transition-colors hover:text-foreground',
      isActive(to) ? 'bg-primary-soft text-foreground' : 'text-muted-foreground',
    );

  return (
    <header className="sticky top-0 z-40 border-b border-border/80 bg-background/85 backdrop-blur">
      <div className="mx-auto grid max-w-7xl grid-cols-[minmax(0,1fr)_auto] items-center gap-4 px-4 py-3 sm:px-6 lg:grid-cols-[auto_1fr_auto]">
        <Link href="/" className="flex min-w-0 items-center gap-2.5">
          <span className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-primary text-primary-foreground">
            <ChefHat className="h-5 w-5" />
          </span>
          <span className="truncate font-display text-lg font-semibold tracking-tight">Culinary Blog</span>
        </Link>

        <nav className="hidden items-center gap-1 justify-self-center lg:flex">
          {links.map((l) => (
            <Link key={l.to} href={l.to} className={navClass(l.to)}>
              {l.label}
            </Link>
          ))}
          {user && (
            <Link href="/dashboard/recipes" className={navClass('/dashboard/recipes')}>
              Bảng điều khiển
            </Link>
          )}
          {user?.role === 'Admin' && (
            <Link href="/dashboard/categories" className={navClass('/dashboard/categories')}>
              Quản lý danh mục
            </Link>
          )}
        </nav>

        <div className="flex shrink-0 items-center gap-2">
          <form onSubmit={submitSearch} className="relative hidden md:block" role="search">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="search"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Tìm công thức…"
              aria-label="Tìm công thức"
              className="field w-52 pl-9 lg:w-64"
            />
          </form>

          {user && (
            <Link
              href="/dashboard/recipes/new"
              className="hidden items-center gap-2 rounded-full bg-accent px-4 py-2 text-sm font-medium text-accent-foreground transition-opacity hover:opacity-90 sm:inline-flex"
            >
              <PenLine className="h-4 w-4" />
              Viết bài
            </Link>
          )}

          <div className="relative">
            <button
              type="button"
              onClick={() => setMenu((v) => !v)}
              aria-label="Menu tài khoản"
              aria-expanded={menu}
              className="grid h-9 w-9 place-items-center overflow-hidden rounded-full bg-secondary text-sm font-semibold text-secondary-foreground"
            >
              {user?.avatarUrl ? (
                // eslint-disable-next-line @next/next/no-img-element
                <img src={user.avatarUrl} alt="" className="h-full w-full object-cover" />
              ) : user ? (
                initialsOf(user.displayName)
              ) : (
                <User className="h-4 w-4" />
              )}
            </button>
            {menu && (
              <div
                className="absolute right-0 mt-2 w-60 overflow-hidden rounded-xl border border-border bg-popover p-1 text-popover-foreground shadow-lift"
                onMouseLeave={() => setMenu(false)}
              >
                <div className="px-3 py-2">
                  <p className="text-sm font-medium">{user?.displayName ?? 'Đang xem với tư cách khách'}</p>
                  <p className="text-xs text-muted-foreground">{user?.email ?? 'Chưa đăng nhập'}</p>
                </div>
                <div className="my-1 h-px bg-border" />

                {!user ? (
                  <MenuLink href="/login" icon={<LogIn className="h-4 w-4" />} label="Đăng nhập" onClick={() => setMenu(false)} />
                ) : (
                  <>
                    <MenuLink href="/profile" icon={<User className="h-4 w-4" />} label="Trang cá nhân" onClick={() => setMenu(false)} />
                    <MenuLink
                      href="/dashboard/recipes"
                      icon={<LayoutDashboard className="h-4 w-4" />}
                      label="Quản lý công thức"
                      onClick={() => setMenu(false)}
                    />
                    {user.role === 'Admin' && (
                      <MenuLink
                        href="/dashboard/categories"
                        icon={<Tags className="h-4 w-4" />}
                        label="Quản lý danh mục"
                        onClick={() => setMenu(false)}
                      />
                    )}
                    <MenuLink
                      href="/recipes"
                      icon={<BookMarked className="h-4 w-4" />}
                      label="Công thức đã lưu"
                      onClick={() => setMenu(false)}
                    />
                    <button
                      type="button"
                      onClick={async () => {
                        setMenu(false);
                        await logout();
                        router.push('/');
                      }}
                      className="flex w-full items-center gap-2 rounded-lg px-3 py-2 text-sm text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
                    >
                      <LogOut className="h-4 w-4" />
                      Đăng xuất
                    </button>
                  </>
                )}
              </div>
            )}
          </div>

          <button
            type="button"
            onClick={() => setOpen((v) => !v)}
            aria-label="Mở menu"
            className="grid h-9 w-9 place-items-center rounded-full border border-border lg:hidden"
          >
            {open ? <X className="h-4 w-4" /> : <Menu className="h-4 w-4" />}
          </button>
        </div>
      </div>

      {open && (
        <div className="border-t border-border bg-background px-4 py-3 lg:hidden">
          <form onSubmit={submitSearch} className="relative mb-3 md:hidden" role="search">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="search"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Tìm công thức…"
              aria-label="Tìm công thức"
              className="field pl-9"
            />
          </form>
          <nav className="flex flex-col">
            {links.map((l) => (
              <Link
                key={l.to}
                href={l.to}
                onClick={() => setOpen(false)}
                className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-secondary hover:text-foreground"
              >
                {l.label}
              </Link>
            ))}
            {user && (
              <Link
                href="/dashboard/recipes"
                onClick={() => setOpen(false)}
                className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-secondary hover:text-foreground"
              >
                Bảng điều khiển
              </Link>
            )}
            {user?.role === 'Admin' && (
              <Link
                href="/dashboard/categories"
                onClick={() => setOpen(false)}
                className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-secondary hover:text-foreground"
              >
                Quản lý danh mục
              </Link>
            )}
            <Link
              href={user ? '/dashboard/recipes/new' : '/login'}
              onClick={() => setOpen(false)}
              className="rounded-lg px-3 py-2 text-sm font-medium text-accent"
            >
              {user ? 'Viết công thức' : 'Đăng nhập'}
            </Link>
          </nav>
        </div>
      )}
    </header>
  );
}

function MenuLink({
  href,
  icon,
  label,
  onClick,
}: {
  href: string;
  icon: ReactNode;
  label: string;
  onClick: () => void;
}) {
  return (
    <Link
      href={href}
      onClick={onClick}
      className="flex w-full items-center gap-2 rounded-lg px-3 py-2 text-sm text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
    >
      {icon}
      {label}
    </Link>
  );
}
