# Quy tắc làm việc nhóm — Culinary Blog

> Tổng hợp từ `CLAUDE.md` và `manifest/README.md`. Khi hai nguồn khác biệt, `CLAUDE.md` là chuẩn.

## Team & phân công module

Mỗi người phụ trách trọn một khối tính năng (DB → API → UI), không chia theo layer.

| Người | GitHub | MSSV | Khối phụ trách | Scope |
|---|---|---|---|---|
| Trần Thị Phương Trang 🧭 (trưởng nhóm) | ChuChoaChan131019 | 2314288 | FR-RCP-001→007 · FR-JOB | `recipes`, `jobs` |
| Đinh Thị Mai Lành | minnhi09 | 2312660 | FR-CAT · FR-SRCH | `categories`, `search` |
| Trần Nguyễn Tuấn Anh | dopaemon | 2312577 | FR-AUTH · FR-OBS | `auth`, `docker` |
| Trần Minh Tài | minhtai05 | 2312740 | FR-RCP-008,009,010 · FR-FILE | `media`, `recipes` |

Ghi chú: structured log/trace của mỗi module do chính người phụ trách module đó thêm, không gom về một người.

---

## 1. Quy ước Commit (Conventional Commits)

Định dạng bắt buộc:

```
<type>(<scope>): <mô tả ngắn>
```

### Danh sách `type`

| Type | Dùng khi | Ví dụ |
|---|---|---|
| `feat` | Thêm tính năng mới | `feat(recipes): thêm api tạo công thức` |
| `fix` | Sửa lỗi | `fix(auth): sửa lỗi refresh token bị revoke sớm` |
| `chore` | Việc lặt vặt, không đổi logic | `chore(deps): cập nhật drizzle-orm lên 0.33` |
| `docs` | Sửa tài liệu, README | `docs(readme): bổ sung hướng dẫn cài minio` |
| `style` | Format code, không đổi logic | `style(frontend): format lại theo prettier` |
| `refactor` | Sửa cấu trúc, không thêm tính năng | `refactor(categories): tách query handler` |
| `perf` | Tối ưu hiệu năng | `perf(search): thêm index cho tsvector` |
| `test` | Thêm hoặc sửa test | `test(auth): thêm unit test cho login handler` |
| `build` | Sửa Dockerfile, cấu hình build | `build(docker): tối ưu layer cache backend` |
| `ci` | Sửa GitHub Actions | `ci: thêm workflow chạy lint` |
| `revert` | Hoàn tác commit trước | `revert: feat(recipes): thêm api tạo công thức` |

### Danh sách `scope`

`auth`, `categories`, `recipes`, `search`, `media`, `jobs`, `shared`, `backend`, `frontend`, `docker`, `deps`.

### Quy tắc viết mô tả

- Viết bằng **tiếng Việt có dấu**, dùng **động từ nguyên thể** ("thêm", "sửa", "xóa" — không dùng "đã thêm", "đang sửa").
- **Không viết hoa** chữ cái đầu, **không chấm** cuối câu.
- Dòng đầu ≤ **72 ký tự**.
- Cần giải thích thêm: để trống 1 dòng rồi viết body; đóng issue bằng `Closes #N`.
- Nhiều người cùng commit: thêm `Co-authored-by: Tên <email>` sau **2 dòng trống**.

### Ví dụ commit đầy đủ

```
feat(auth): thêm cơ chế refresh token rotation

Mỗi lần refresh, token cũ được đánh dấu isRevoked = true và sinh
token mới. Phát hiện reuse attack sẽ ghi log cảnh báo mức WARNING.

Closes #12
```

```
feat(recipes): thêm api upload ảnh công thức


Co-authored-by: Trần Minh Tài <2312740@dlu.edu.vn>
```

---

## 2. Quy ước Branch

```
<type>/<scope>-<mô-tả-ngắn>
```

| Ví dụ | Ý nghĩa |
|---|---|
| `feat/auth-google-oauth` | Thêm đăng nhập Google |
| `fix/recipes-n-plus-one` | Sửa lỗi N+1 query |
| `docs/readme-deployment` | Bổ sung hướng dẫn triển khai |

- Chữ thường, không dấu tiếng Việt, ngăn cách bằng dấu gạch ngang.
- **Không commit thẳng vào `main`** — mọi thay đổi phải qua Pull Request.
- Xóa branch sau khi PR đã merge.

---

## 3. Quy ước Pull Request

### Tiêu đề PR (bắt buộc)

```
Tên-MSSV: Title
```

| Thành viên | Tiêu đề PR mẫu |
|---|---|
| Trần Thị Phương Trang | `Trang-2314288: Thêm CRUD công thức nấu ăn` |
| Đinh Thị Mai Lành | `Lành-2312660: Hoàn thiện Full-Text Search tiếng Việt` |
| Trần Nguyễn Tuấn Anh | `TuấnAnh-2312577: Thêm cơ chế refresh token rotation` |
| Trần Minh Tài | `Tài-2312740: Tích hợp upload ảnh lên MinIO` |

### Mô tả PR (bắt buộc — PR không có mô tả sẽ bị đóng)

Phải trả lời được: làm gì, tại sao, kiểm thử thế nào. Dùng template:

```
## Mô tả
## Yêu cầu liên quan (FR-xxx)
## Thay đổi chính
## Cách kiểm thử
## Ảnh chụp màn hình
## Checklist
- [ ] Code chạy được ở local
- [ ] Đã chạy pnpm lint và pnpm typecheck
- [ ] Không commit file .env
- [ ] Đã tự review lại diff
```

### Quy tắc review & merge

- Mỗi PR cần **≥1 approve** trước khi merge.
- PR chạm `packages/shared`, `docker-compose.yml` hoặc config chung → cần người phụ trách FR-AUTH/FR-OBS (dopaemon) review.
- PR nên **< 400 dòng thay đổi** — quá lớn thì tách nhỏ.
- Merge bằng **Squash and merge** để giữ lịch sử `main` gọn.
- Người tạo PR tự giải quyết conflict trước khi merge.

---

## 4. Cấu trúc thư mục & nguồn UI

- Đặt file mới đúng theo layout tại `Docs/Tree.md` — không tự bịa cấu trúc khác.
- Mọi trang/component ở `apps/frontend` phải **port** từ `tasty-tale-hub-30/` (UI mockup Lovable), không tự vẽ giao diện mới. Xem bảng mapping route/component trong `CLAUDE.md`.

## 5. Nguồn nghiệp vụ

- `SRS.md` (xem bản Markdown tại `Docs/SRS.md`) là nguồn **nghiệp vụ** duy nhất: FR chi tiết, business rules, endpoint, status code, data model, error codes.
- Bản SRS viết mẫu theo stack .NET — **chỉ lấy phần nghiệp vụ**, bỏ qua chi tiết công nghệ .NET cụ thể, map sang stack JS thật theo bảng trong `CLAUDE.md`.
