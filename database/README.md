# Database mẫu — chia sẻ cho team

Thư mục này chứa 1 bản snapshot của database local (đã seed sẵn danh mục, công thức...) và file `.env` khớp với snapshot đó, để mọi người trong team có **cùng một bộ dữ liệu** khi chạy local, khỏi mất công tự seed lại.

> ⚠️ `.env` ở đây chỉ chứa giá trị **dev-only mặc định** (giống `.env.example`), không có secret thật (Google OAuth vẫn để placeholder). Không copy secret thật vào đây, không dùng file này cho production.

## Nội dung

| File | Dùng khi |
|---|---|
| `culinary_blog.dump` | Restore bằng `pg_restore` (custom format, nhanh, hỗ trợ restore song song) — **khuyến nghị** |
| `culinary_blog.sql` | Restore bằng `psql` (plain SQL, đọc được bằng text editor nếu cần) |
| `.env` | Copy đè lên `.env` ở root repo để dùng chung config với snapshot này |

## Cách import vào Docker

### Bước 1 — Copy `.env`

```bash
cp database/.env .env
```

### Bước 2 — Khởi động Postgres (chưa chạy migration/seed gì cả)

```bash
docker compose up -d postgres
docker compose ps   # đợi tới khi postgres "healthy"
```

### Bước 3 — Restore dữ liệu

**Cách A — dùng file `.dump` (khuyến nghị):**

```bash
docker compose cp database/culinary_blog.dump postgres:/tmp/culinary_blog.dump
docker compose exec postgres pg_restore -U culinary -d culinary_blog --clean --if-exists /tmp/culinary_blog.dump
```

**Cách B — dùng file `.sql`:**

```bash
docker compose exec -T postgres psql -U culinary -d culinary_blog < database/culinary_blog.sql
```

> Nếu database đã có sẵn dữ liệu khác và muốn thay hẳn bằng snapshot này, xóa sạch trước khi restore:
> ```bash
> docker compose exec -T postgres psql -U culinary -d culinary_blog -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
> ```

### Bước 4 — Kiểm tra

```bash
docker compose exec -T postgres psql -U culinary -d culinary_blog -c "SELECT count(*) FROM recipes;"
```

### Bước 5 — Chạy phần còn lại của hạ tầng rồi start dự án

```bash
docker compose up -d redis minio
pnpm install
pnpm dev
# hoặc chạy full Docker: docker compose up -d --build
```

Xem thêm hướng dẫn chạy dự án đầy đủ (Swagger, port, lấy Bearer token...) ở [`manifest/README.md`](https://github.com/PTUDW-2026-Nhom2/manifest).

## Cách tự tạo snapshot mới (khi muốn cập nhật)

```bash
docker compose exec -T postgres pg_dump -U culinary -d culinary_blog -F c -f /tmp/culinary_blog.dump
docker compose cp postgres:/tmp/culinary_blog.dump ./database/culinary_blog.dump

docker compose exec -T postgres pg_dump -U culinary -d culinary_blog --no-owner --no-privileges > database/culinary_blog.sql
```
