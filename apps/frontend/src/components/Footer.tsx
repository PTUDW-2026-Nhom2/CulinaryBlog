import { ChefHat } from "lucide-react";
import Link from "next/link";

// Mockup có 4 cột (kèm "Kitchen"/"About" trỏ về "/" và icon social không link) — ở đây
// chỉ giữ những đường dẫn có route thật, thêm dần khi các trang tương ứng lên.
const columns = [
  {
    title: "Khám phá",
    items: [
      { label: "Tất cả công thức", href: "/recipes" },
      { label: "Danh mục", href: "/categories" },
      { label: "Tìm kiếm", href: "/search" },
    ],
  },
  {
    title: "Đóng góp",
    items: [
      { label: "Viết công thức", href: "/dashboard/recipes/new" },
      { label: "Công thức của tôi", href: "/dashboard/recipes" },
    ],
  },
  {
    title: "Tài khoản",
    items: [
      { label: "Đăng nhập", href: "/login" },
      { label: "Đăng ký", href: "/register" },
      { label: "Trang cá nhân", href: "/profile" },
    ],
  },
] as const;

export function Footer() {
  return (
    <footer className="mt-24 border-t border-border bg-surface">
      <div className="mx-auto grid max-w-7xl gap-10 px-4 py-14 sm:px-6 md:grid-cols-[1.4fr_1fr_1fr_1fr]">
        <div className="max-w-sm">
          <div className="flex items-center gap-2.5">
            <span className="grid h-9 w-9 place-items-center rounded-xl bg-primary text-primary-foreground">
              <ChefHat className="h-5 w-5" aria-hidden />
            </span>
            <span className="font-display text-lg font-semibold">Culinary Blog</span>
          </div>
          <p className="mt-4 text-sm leading-relaxed text-muted-foreground">
            Công thức nấu ăn với thời gian thật, nguyên liệu đầy đủ và từng bước rõ ràng — do chính
            người nấu chia sẻ.
          </p>
        </div>

        {columns.map((col) => (
          <div key={col.title}>
            <h3 className="font-display text-sm font-semibold uppercase tracking-wider">
              {col.title}
            </h3>
            <ul className="mt-4 space-y-2.5">
              {col.items.map((item) => (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className="text-sm text-muted-foreground transition-colors hover:text-foreground"
                  >
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
      <div className="border-t border-border">
        <div className="mx-auto flex max-w-7xl flex-col gap-2 px-4 py-5 text-xs text-muted-foreground sm:flex-row sm:items-center sm:justify-between sm:px-6">
          <p>© {new Date().getFullYear()} Culinary Blog. Đồ án Phát triển ứng dụng web.</p>
          <p>PTUDW 2026 — Nhóm 2</p>
        </div>
      </div>
    </footer>
  );
}
