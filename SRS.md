# Culinary Blog — Tài liệu Đặc tả Yêu cầu Phần mềm (SRS)

> Chuyển đổi nội dung chính từ `SRS_Culinary_Blog_v1.0.0.pdf` (bản 1.0.0, 04/06/2026, Đã duyệt, IEEE 830/ISO 29148).
>
> ⚠️ **Lưu ý stack**: bản gốc viết mẫu theo .NET 10 + EF Core + Hangfire + Serilog + ASP.NET Core Identity. Giảng viên đã cho phép đổi sang stack JS thật của repo (NestJS/Drizzle/BullMQ/Passport+argon2/Pino) — xem bảng mapping trong `CLAUDE.md`. Tài liệu này giữ nguyên **nghiệp vụ** (FR, business rules, endpoint, status code, data model) từ bản gốc; chi tiết công nghệ .NET cụ thể chỉ mang tính tham chiếu lịch sử.

## Mục lục

1. [Giới thiệu](#1-giới-thiệu)
2. [Mô tả Tổng quan Hệ thống](#2-mô-tả-tổng-quan-hệ-thống)
3. [Yêu cầu Chức năng Chi tiết](#3-yêu-cầu-chức-năng-chi-tiết)
4. [Yêu cầu Phi Chức năng (NFR)](#4-yêu-cầu-phi-chức-năng-nfr)
5. [Yêu cầu Giao diện Ngoài](#5-yêu-cầu-giao-diện-ngoài)
6. [Kiến trúc Hệ thống](#6-kiến-trúc-hệ-thống)
7. [Mô hình Dữ liệu](#7-mô-hình-dữ-liệu)
8. [Đặc tả REST API](#8-đặc-tả-rest-api)
- [Phụ lục A – HTTP Status Codes](#phụ-lục-a--http-status-codes)
- [Phụ lục B – Application Error Codes](#phụ-lục-b--application-error-codes)
- [Phụ lục C – Từ điển Thuật ngữ](#phụ-lục-c--từ-điển-thuật-ngữ)

---

## 1. Giới thiệu

### 1.1. Mục đích Tài liệu

Mô tả đầy đủ, chính xác và nhất quán toàn bộ yêu cầu chức năng (FR) và phi chức năng (NFR) của Culinary Blog. Phục vụ: nhóm Backend, nhóm Frontend, QA/QC, kiến trúc sư hệ thống, giảng viên/sinh viên, stakeholder/product owner.

Phạm vi hiệu lực: từ phiên bản 1.0.0, là baseline cho toàn bộ vòng đời dự án. Thay đổi yêu cầu sau khi phê duyệt phải qua Change Management Process.

### 1.2. Phạm vi Sản phẩm

| Thuộc tính | Giá trị |
|---|---|
| Tên sản phẩm | Culinary Blog – Blog Ẩm thực và Nấu ăn |
| Định danh dự án | CULINARY-BLOG-V1 |
| Loại hệ thống | Ứng dụng Web Full-Stack (API-Driven Architecture) |
| Phiên bản sản phẩm | 1.0.0 |
| Môi trường đích | Cloud/On-premise (Docker Compose + Nginx) |

**Mô tả sản phẩm**: nền tảng web cho phép người dùng chia sẻ, khám phá và lưu trữ công thức nấu ăn từ nhiều nền ẩm thực khác nhau:

- **Nền tảng chia sẻ công thức**: Author đăng tải công thức với hình ảnh, nguyên liệu chi tiết, hướng dẫn từng bước, thông tin dinh dưỡng.
- **Tổ chức nội dung**: phân loại theo Category, Difficulty Level, thời gian chuẩn bị/nấu.
- **Tìm kiếm thông minh**: Full-Text Search tiếng Việt (PostgreSQL tsvector/tsquery + unaccent).
- **Bảo mật đa lớp**: JWT stateless, RBAC + Resource-Based Authorization, Google OAuth 2.0.
- **Tối ưu hiệu năng & SEO**: distributed cache, ISR, Open Graph, JSON-LD Schema.org Recipe.
- **Quan sát hệ thống**: structured logging, distributed tracing, health check endpoints.

**Ngoài phạm vi (v1.0.0)**: Comment/Rating system, Bookmark/Favorite, real-time notification (SignalR/WebSocket), app mobile native, thanh toán/e-commerce, nhắn tin trực tiếp, GraphQL API.

### 1.3. Định nghĩa, Từ viết tắt & Ký hiệu (tóm tắt)

SRS, FR, NFR, API, REST, JWT, RBAC, CQRS, DDD, ORM, FTS, ISR, LCP, CLS, INP, CI/CD, TTL, SSR, SSG, MoSCoW, RFC, ERD, PBKDF2, CDN, MIME, JSON-LD — định nghĩa đầy đủ ở [Phụ lục C](#phụ-lục-c--từ-điển-thuật-ngữ).

**MoSCoW**: M (Must Have – bắt buộc), S (Should Have – nên có), C (Could Have – có thể có), W (Won't Have – ngoài scope hiện tại).

### 1.4. Tài liệu Tham chiếu

IEEE Std 830-1998, ISO/IEC/IEEE 29148:2018, OWASP Top 10:2021, RFC 7807, RFC 7519, RFC 6749, .NET 10 Minimal APIs, ASP.NET Core Identity, EF Core 10, Next.js 15 App Router, PostgreSQL 16 FTS, Redis 7, MinIO S3, Google Web Vitals, Schema.org Recipe, OpenTelemetry .NET, Serilog, Hangfire, FluentValidation.

### 1.5. Tổng quan Tài liệu

8 chương chính + 3 phụ lục: Ch.2 Tổng quan, Ch.3 27 FR (7 module), Ch.4 NFR, Ch.5 Giao diện ngoài, Ch.6 Kiến trúc, Ch.7 Mô hình dữ liệu, Ch.8 REST API (~30 endpoint), Phụ lục A-C (HTTP codes, App error codes, thuật ngữ).

---

## 2. Mô tả Tổng quan Hệ thống

### 2.1. Bối cảnh Sản phẩm

Hệ thống vận hành theo mô hình **API-Driven Architecture**: Backend và Frontend là hai hệ thống độc lập giao tiếp hoàn toàn qua HTTP/JSON RESTful API. Không có server-side rendering truyền thống (MVC Razor/Blazor) hay shared view engine giữa hai tầng.

**Quan hệ với hệ thống ngoài**:

| Hệ thống ngoài | Vai trò | Giao thức | Hướng tích hợp |
|---|---|---|---|
| PostgreSQL 16 | RDBMS chính | TCP + ORM driver | Backend → PostgreSQL |
| Redis 7 | Distributed Cache & Session Store | TCP | Backend → Redis |
| MinIO (S3) | Object Storage cho ảnh công thức | HTTP/S3 API | Backend → MinIO |
| Google OAuth 2.0 | Đăng nhập bên thứ ba (Identity Provider) | HTTPS + OpenID Connect | Client ↔ Google ↔ Backend |
| Background Job Queue | Xử lý job nền | In-process/queue | Backend (internal) |
| Structured Log Aggregation | Log tập trung (dev) | HTTP Sink → Seq | Backend → Seq |
| OpenTelemetry Collector | Distributed tracing & metrics (prod) | OTLP/gRPC | Backend → Collector |
| Nginx (Reverse Proxy) | SSL termination, load balancing, static serving | HTTP/HTTPS | Client → Nginx → Services |

### 2.2. Chức năng Sản phẩm Tổng quát

7 nhóm chức năng chính, 27 Functional Requirements:

| Nhóm chức năng | Mã nhóm | Số FR | Mô tả tóm tắt |
|---|---|---|---|
| Xác thực & Quản lý Người dùng | FR-AUTH | 7 | Đăng ký, đăng nhập (email + Google), JWT refresh token, logout, quản lý profile |
| Quản lý Danh mục | FR-CAT | 5 | CRUD danh mục công thức (Category) – phân quyền Admin |
| Quản lý Công thức nấu ăn | FR-RCP | 10 | CRUD recipe, publish/archive, quản lý ảnh/bước/nguyên liệu |
| Tìm kiếm & Phân trang | FR-SRCH | 4 | Full-Text Search (PostgreSQL), filter, sort, offset pagination |
| Quản lý Tệp tin | FR-FILE | 2 | Upload/Delete ảnh trên MinIO S3-compatible |
| Background Jobs | FR-JOB | 3 | Email chào mừng, thumbnail generation, sitemap XML |
| Quan sát Hệ thống | FR-OBS | 3 | Health checks, structured logging, distributed tracing |

### 2.3. Các Lớp Người dùng và Đặc điểm

| Vai trò | Mô tả | Điều kiện | Quyền hạn chính | Ưu tiên phục vụ |
|---|---|---|---|---|
| Khách (Guest/Anonymous) | Chưa xác thực | Không cần tài khoản | Xem danh sách & chi tiết recipe (Published), xem danh mục, tìm kiếm. KHÔNG được tạo/sửa/xóa. | Cao (đại đa số người dùng) |
| Tác giả (Author) | Đã đăng ký & xác thực thành công; tự động gán khi đăng ký | Có tài khoản & JWT hợp lệ | Tất cả quyền Guest + Tạo/sửa/xóa recipe CỦA MÌNH + upload ảnh, quản lý steps/ingredients + Publish/Archive recipe của mình | Cao (nhà sản xuất nội dung) |
| Quản trị viên (Admin) | Quyền cao nhất; gán thủ công qua database seeding | Có tài khoản & role Admin | Tất cả quyền Author + CRUD danh mục + sửa/xóa bất kỳ recipe của bất kỳ Author + truy cập Dashboard job + xem structured logs | Trung bình (số lượng ít) |

**Ghi chú phân quyền** — 3 tầng:
1. **Role-Based Authorization**: phân biệt quyền dựa trên role (Guest/Author/Admin).
2. **Resource-Based Authorization**: Author chỉ sửa/xóa được recipe của chính mình (AuthorId == currentUserId).
3. **Policy-Based Authorization**: Policy "VerifiedAuthor" yêu cầu email đã xác nhận. Admin có quyền bypass resource ownership check.

### 2.4. Môi trường Vận hành (tham khảo — đã map sang JS stack thật)

Xem `CLAUDE.md` cho tech stack thực tế (NestJS/Next.js/Drizzle/Redis/MinIO/BullMQ/Docker Compose). Yêu cầu tài nguyên tối thiểu production: 2 vCPU, 4GB RAM, 20GB SSD; khuyến nghị 4+ vCPU, 8GB+ RAM, 50GB+ SSD.

**Trình duyệt hỗ trợ**: Chrome/Edge 90+, Firefox 88+, Safari 14+ (macOS 11+), Mobile Chrome/Safari (responsive). **Không hỗ trợ** Internet Explorer (EOL).

### 2.5. Ràng buộc Thiết kế và Hiện thực

| Mã | Loại | Mô tả ràng buộc |
|---|---|---|
| CONS-001 | Kiến trúc | Backend phải tuân thủ Clean Architecture 4 tầng: Domain, Application, Infrastructure, Presentation. Domain không phụ thuộc thư viện ngoài. |
| CONS-002 | Pattern | CQRS bắt buộc cho tầng Application. Mỗi use case là Command hoặc Query Handler riêng biệt. |
| CONS-003 | Ngôn ngữ/Framework | (Bản gốc: .NET Minimal APIs / Next.js App Router). Thực tế: NestJS Controllers + `@nestjs/cqrs`; Frontend Next.js App Router (không dùng Pages Router). |
| CONS-004 | Bảo mật | Xác thực PHẢI dùng JWT stateless (access 15 phút, refresh 7 ngày). Mật khẩu PHẢI hash (bản gốc PBKDF2 → thực tế **argon2**). |
| CONS-005 | API Design | API PHẢI tuân thủ RESTful. Phản hồi lỗi PHẢI theo RFC 7807 (`application/problem+json`). Versioning qua URL path (`/api/v1/`). |
| CONS-006 | Database | PostgreSQL là DBMS duy nhất. Migrations qua ORM code-first (bản gốc EF Core → thực tế **Drizzle**). Không viết raw SQL trực tiếp, dùng parameterized query. |
| CONS-007 | File Upload | Kích thước tối đa 5MB. Định dạng: image/jpeg, image/png, image/webp, image/avif. Kiểm tra MIME type qua magic bytes (không chỉ extension). |
| CONS-008 | Validation | Input validation PHẢI qua pipeline behavior (bản gốc FluentValidation+MediatR → thực tế `class-validator` + NestJS pipes). Không validate trong handler. |
| CONS-009 | Container | Ứng dụng PHẢI đóng gói Docker. Multi-stage build. Docker Compose cho local dev. |
| CONS-010 | Logging | Structured logging bắt buộc (bản gốc Serilog → thực tế **Pino/nestjs-pino**). Mọi log entry PHẢI có CorrelationId, RequestPath, UserId (khi đã xác thực). |

### 2.6. Giả định và Phụ thuộc

**Giả định**:
- Môi trường dev có kết nối Internet để pull Docker images và package.
- PostgreSQL, Redis, MinIO cung cấp qua Docker Compose (dev) hoặc managed service/VPS (production).
- Người dùng cuối có trình duyệt hiện đại và kết nối Internet ổn định để load ảnh từ MinIO.
- Dữ liệu seed: 50 recipe mẫu, 5 tác giả mẫu.
- Email service (SendGrid/SMTP) cấu hình sẵn khi triển khai production.
- **Giới hạn dữ liệu kỳ vọng (initial scale)**: ≤ 10.000 công thức, ≤ 5.000 người dùng, ≤ 50 danh mục — phù hợp single-server deployment.

**Phụ thuộc bên ngoài** (mức ảnh hưởng nếu không khả dụng):

| Phụ thuộc | Mức ảnh hưởng | Kế hoạch dự phòng |
|---|---|---|
| Google OAuth 2.0 API | Cao – mất chức năng đăng nhập Google | Vẫn đăng nhập email/password; hiển thị thông báo tạm thời |
| MinIO / S3 | Cao – không upload/xem được ảnh | Fallback local filesystem (dev only); production cần MinIO |
| Redis | Trung bình – mất cache, hiệu năng giảm | Query database trực tiếp; cache miss graceful degradation |
| PostgreSQL | Rất cao – toàn bộ hệ thống ngừng | Backup định kỳ (pg_dump); readiness probe fail → Nginx trả 503 |
| Background Job Queue | Thấp – job không chạy | Fire-and-forget job mất; recurring job bỏ qua chu kỳ; không ảnh hưởng core functionality |

---

## 3. Yêu cầu Chức năng Chi tiết

27 FR nhóm thành 7 module. Template mỗi FR: Mã, Tên, Nhóm, Tác nhân, Ưu tiên (MoSCoW), Mô tả, Điều kiện tiên quyết, Luồng chính, Luồng thay thế/Ngoại lệ, HTTP Endpoint, Kết quả mong đợi, HTTP Status Code.

### 3.1. Module Xác thực và Quản lý Người dùng (FR-AUTH)

Quản lý toàn bộ vòng đời xác thực: đăng ký, đăng nhập đa phương thức, duy trì phiên với token rotation, quản lý hồ sơ.

#### FR-AUTH-001: Đăng ký Tài khoản (M)
- **Tác nhân**: Guest.
- **Mô tả**: tạo tài khoản mới bằng email/password; tự động gán role "Author"; auto-login sau đăng ký; gửi job email chào mừng.
- **Luồng chính**: validate input (fullName, email hợp lệ, username không ký tự đặc biệt, password ≥8 ký tự gồm 1 hoa/1 số/1 ký tự đặc biệt) → kiểm tra email chưa tồn tại → tạo user, hash password → gán role Author → sinh access token (15p) + refresh token (7 ngày, 512-bit random, lưu hash) → enqueue welcome email job → trả 201 với `{accessToken, refreshToken, expiresAt, user}`.
- **Ngoại lệ**: A1 email tồn tại → 409 Conflict; A2 password không đủ mạnh → 422; A3 validation lỗi → 422 (RFC 7807); A4 DB lỗi → 500.
- **Endpoint**: `POST /api/v1/auth/register`.

#### FR-AUTH-002: Đăng nhập Email/Mật khẩu (M)
- **Tác nhân**: Author/Admin.
- **Mô tả**: đăng nhập tạo cặp token mới mỗi lần. Token Rotation: refresh token cũ KHÔNG xóa ngay mà đánh dấu đã dùng (chống reuse attack).
- **Luồng chính**: tìm user theo email → verify password → kiểm tra không bị lockout → sinh access+refresh token mới → lưu DB → reset AccessFailedCount → trả 200.
- **Ngoại lệ**: A1 sai email/password → 401 generic message (chống User Enumeration); A2 tài khoản lockout → 423 Locked; A3 sai 5 lần → lockout 15 phút.
- **Endpoint**: `POST /api/v1/auth/login`.

#### FR-AUTH-003: Đăng nhập Google OAuth 2.0 (S)
- **Tác nhân**: Guest (lần đầu) / user đã đăng ký qua Google.
- **Mô tả**: OAuth 2.0 Authorization Code Flow + PKCE. Lần đầu → tạo tài khoản mới, gán role Author. Email đã tồn tại (đăng ký thủ công trước) → liên kết tài khoản, không tạo mới.
- **Luồng chính**: FE redirect Google → user consent → callback → FE gửi `POST /auth/google` với idToken → BE tìm user theo Google login info → tạo mới hoặc liên kết → trả token.
- **Ngoại lệ**: A1 Google token invalid/expired → 401; A2 email bị revoke quyền → 400; A3 Google API không khả dụng → 502.
- **Endpoint**: `POST /api/v1/auth/google`.

#### FR-AUTH-004: Làm mới Access Token (Token Refresh) (M)
- **Mô tả**: dùng refresh token còn hiệu lực lấy cặp token mới không cần đăng nhập lại. **Token Rotation bắt buộc**: mỗi lần refresh, token cũ bị vô hiệu hóa (revoke) và token mới được tạo — chống Refresh Token Reuse Attack.
- **Luồng chính**: tìm refresh token trong DB → kiểm tra tồn tại, chưa revoke, chưa hết hạn, user active → đánh dấu token cũ đã revoke, `replacedByToken = newToken` → sinh token mới → trả 200.
- **Ngoại lệ**: A1 token không tìm thấy → 401; A2 hết hạn → 401; A3 **đã bị revoke (reuse attack detected)** → 401 + **LOG SECURITY ALERT (WARNING)**, có thể revoke toàn bộ refresh token family (paranoid mode); A4 user bị xóa/khóa → 401.
- **Endpoint**: `POST /api/v1/auth/refresh`.

#### FR-AUTH-005: Đăng xuất (Logout / Token Revocation) (M)
- **Mô tả**: JWT access token stateless nên logout chủ yếu revoke refresh token tương ứng trong DB. Client tự xóa access token phía client.
- **Luồng chính**: xác thực JWT → tìm refresh token → nếu thuộc user hiện tại → đánh dấu revoked → 204 No Content.
- **Ngoại lệ**: A1 refresh token không tìm thấy → vẫn 204 (idempotent); A2 access token hết hạn → vẫn cho logout nếu refresh token hợp lệ, hoặc 401 nếu không cung cấp.
- **Endpoint**: `POST /api/v1/auth/logout`.

#### FR-AUTH-006: Xem Hồ sơ Cá nhân (View Profile) (S)
- **Mô tả**: trả thông tin hồ sơ dựa trên UserId từ JWT claims. Không bao giờ trả PasswordHash/SecurityStamp.
- **Luồng chính**: xác thực JWT → trích UserId → query user → map DTO `{id, fullName, email, userName, avatarUrl, roles, emailConfirmed, createdAt}` → 200.
- **Ngoại lệ**: A1 user bị xóa sau khi cấp token → 404.
- **Endpoint**: `GET /api/v1/auth/me`.

#### FR-AUTH-007: Cập nhật Hồ sơ Cá nhân (Update Profile) (S)
- **Mô tả**: cập nhật FullName/AvatarUrl. Email và UserName **không** đổi qua endpoint này. PATCH (partial update).
- **Luồng chính**: validate (fullName 2–100 ký tự, avatarUrl là URL hợp lệ nếu có) → cập nhật field được cung cấp → trả 200 với profile mới.
- **Ngoại lệ**: A1 dữ liệu không hợp lệ → 422.
- **Endpoint**: `PATCH /api/v1/auth/me`.

### 3.2. Module Quản lý Danh mục (FR-CAT)

Category tạo/duy trì bởi Admin; Author/Guest chỉ đọc. Slug duy nhất phục vụ SEO. Cache TTL 1 giờ, invalidate khi thay đổi.

#### FR-CAT-001: Xem Danh sách Danh mục (M)
- Tất cả (Guest/Author/Admin). Trả danh sách tất cả danh mục kèm số công thức Published mỗi danh mục. Cache 60 phút (sliding), sort theo Name tăng dần.
- Endpoint: `GET /api/v1/categories`. 200 OK (kể cả rỗng `[]`).

#### FR-CAT-002: Xem Chi tiết Danh mục và Công thức (M)
- Trả chi tiết danh mục theo Slug kèm danh sách phân trang công thức Published thuộc danh mục. Guest chỉ thấy Published; Author thấy thêm Draft của chính mình.
- Endpoint: `GET /api/v1/categories/{slug}?page={n}&pageSize={n}`. 200 OK / 404 Not Found (slug không tồn tại).

#### FR-CAT-003: Tạo Danh mục Mới [Admin] (M)
- Slug tự động sinh từ Name (slugify), nếu trùng thêm suffix số. Sau khi tạo, invalidate cache "categories:all".
- Luồng: kiểm tra role Admin → validate (2–50 ký tự, không HTML) → generate slug unique → tạo entity → invalidate cache → 201 Created.
- Ngoại lệ: A1 thiếu role Admin → 403; A2 dữ liệu không hợp lệ → 422; name đã tồn tại → 409.
- Endpoint: `POST /api/v1/categories`.

#### FR-CAT-004: Cập nhật Danh mục [Admin] (M)
- Cập nhật Name/Description. **Slug KHÔNG đổi** khi đổi tên (tránh broken links). Invalidate cache sau cập nhật.
- Endpoint: `PUT /api/v1/categories/{id:guid}`. 200/403/404/422.

#### FR-CAT-005: Xóa Danh mục [Admin] (S)
- Business rule: **KHÔNG được xóa danh mục còn chứa công thức** (Published hay Draft) — soft constraint bảo vệ toàn vẹn dữ liệu. Admin phải chuyển hết công thức sang danh mục khác trước.
- Luồng: đếm recipe trong category → nếu >0 → 409 Conflict "Danh mục còn chứa {count} công thức." → nếu 0 → xóa, invalidate cache → 204 No Content.
- Endpoint: `DELETE /api/v1/categories/{id:guid}`.

### 3.3. Module Quản lý Công thức Nấu ăn (FR-RCP)

Module cốt lõi. Recipe là aggregate root chứa child entities: RecipeStep, RecipeIngredient, RecipeImage, và Owned Entity RecipeNutrition. Mọi mutation đi qua transaction nhất quán. Concurrency xử lý qua RowVersion (Timestamp) để phát hiện lost update.

#### FR-RCP-001: Xem Danh sách Công thức — Paginated + Filtered + Sorted (M)
- Guest/Author khác chỉ thấy Status == Published. Author thấy thêm Draft/Archived của chính mình. Admin thấy tất cả trạng thái.
- Filter: CategoryId, Difficulty, thời gian nấu. Sort: createdAt, title, cookTime. Cache (TTL 15 phút, vary by query).
- Endpoint: `GET /api/v1/recipes?page={n}&pageSize={n}&categoryId={guid}&difficulty={level}&maxCookTime={min}&sort={field}`.
- Kết quả: `PagedResult<RecipeSummaryDto>: {items[], totalCount, page, pageSize, totalPages, hasNextPage, hasPreviousPage}`.
- Ngoại lệ: A1 page/pageSize không hợp lệ → 422; A2 categoryId không tồn tại → 200 với items rỗng (không throw 404).

#### FR-RCP-002: Xem Chi tiết Công thức (M)
- Trả toàn bộ thông tin: cơ bản, RecipeIngredient[] (sort SortOrder), RecipeStep[] (sort StepNumber), RecipeImage[], RecipeNutrition, category, author. Recipe Draft/Archived chỉ tác giả sở hữu hoặc Admin xem được. Cache 60 phút, tag "recipes" cho tag-based invalidation.
- Endpoint: `GET /api/v1/recipes/{slug}`. 200 / 403 Forbidden (không quyền xem Draft) / 404 Not Found.

#### FR-RCP-003: Tạo Công thức Nấu ăn Mới [Author/Admin] (M)
- Trạng thái ban đầu luôn **Draft**. Slug tự sinh từ Title (unique). Steps/Ingredients có thể tạo cùng lúc hoặc thêm riêng lẻ sau (FR-RCP-009/010).
- Luồng: validate (title 5–200, prepTime/cookTime/servings > 0, categoryId hợp lệ) → generate slug unique → tạo recipe + steps + ingredients + nutrition nếu có → invalidate cache "recipes" → 201 Created.
- Ngoại lệ: A1 không có quyền → 401/403; A2 categoryId không tồn tại → 422; A3 slug/title trùng → 409.
- Endpoint: `POST /api/v1/recipes`.

#### FR-RCP-004: Cập nhật Công thức [Author-Owner/Admin] (M)
- Resource-Based Authorization: chỉ Author sở hữu (AuthorId == currentUserId) hoặc Admin. Concurrency control qua RowVersion (ETag pattern): client gửi RowVersion hiện tại (If-Match header hoặc body); mismatch → conflict.
- Luồng: kiểm tra authorization → kiểm tra RowVersion → cập nhật field qua domain method → cập nhật Nutrition nếu có → save (mismatch → 409) → invalidate cache theo tag → 200 OK.
- Ngoại lệ: A1 không phải owner → 403; A2 concurrency conflict → 409; A3 ID không tồn tại → 404.
- Endpoint: `PUT /api/v1/recipes/{id:guid}`.

#### FR-RCP-005: Xuất bản / Hủy Xuất bản Công thức (M)
- Thay đổi trạng thái Draft ↔ Published. **Business rule: KHÔNG thể publish nếu recipe không có ít nhất 1 bước thực hiện (Steps.Count > 0)**. Khi publish, recipe trở nên công khai và được đưa vào index tìm kiếm.
- Luồng: kiểm tra resource-based authorization → domain method publish/unpublish → publish kiểm tra Steps.Count == 0 → throw DomainException → set Status/UpdatedAt → invalidate cache → 200 OK.
- Ngoại lệ: A1 recipe không có bước thực hiện → 422 với DomainException message; A2 recipe đã ở trạng thái mong muốn → idempotent, trả 200.
- Endpoint: `PATCH /api/v1/recipes/{id:guid}/publish` | `PATCH /api/v1/recipes/{id:guid}/unpublish`.

#### FR-RCP-006: Lưu trữ Công thức (Archive) (S)
- Chuyển Recipe sang trạng thái Archived: không hiển thị trong danh sách công khai nhưng không xóa khỏi database (soft hide).
- Endpoint: `PATCH /api/v1/recipes/{id:guid}/archive`. 200 OK / 403 / 404.

#### FR-RCP-007: Xóa Công thức [Author-Owner/Admin] (M)
- Xóa vĩnh viễn recipe và tất cả dữ liệu liên quan (cascade delete: Steps, Ingredients, Images). Ảnh trên MinIO xóa bất đồng bộ qua background job (fire-and-forget) để tránh blocking. **Đây là hard delete** (không dùng soft delete pattern cho recipe).
- Luồng: kiểm tra authorization → lấy danh sách URL ảnh → cascade delete DB → enqueue job xóa ảnh trên MinIO (retry tối đa 3 lần nếu fail, không ảnh hưởng response) → invalidate cache → 204 No Content.
- Endpoint: `DELETE /api/v1/recipes/{id:guid}`.

#### FR-RCP-008: Quản lý Ảnh Công thức — Upload / Set Primary / Delete (M)
- Upload dùng multipart/form-data. Ảnh lưu trên MinIO path `recipes/{recipeId}/{uuid}.{ext}`. Ảnh đầu tiên tự động đặt làm ảnh chính (IsPrimary = true). Validation bắt buộc: MIME type (image/jpeg, png, webp, avif) + magic bytes + kích thước tối đa 5MB.
- **UPLOAD**: `POST /api/v1/recipes/{id}/images` (multipart field "file") → validate MIME/size/magic bytes → upload → 201 `{url, isPrimary}`.
- **SET PRIMARY**: `PATCH /api/v1/recipes/{id}/images/{imageId}/primary` → 200 OK.
- **DELETE**: `DELETE /api/v1/recipes/{id}/images/{imageId}` → xóa DB, enqueue xóa MinIO async; nếu ảnh xóa là primary và còn ảnh khác → tự động đặt ảnh đầu tiên còn lại làm primary → 204 No Content.
- Ngoại lệ: A1 MIME invalid → 400; A2 file >5MB → 400; A3 magic bytes không khớp MIME → 400; A4 MinIO không khả dụng → 503.

#### FR-RCP-009: Quản lý Nguyên liệu (CRUD RecipeIngredient) (M)
- Mỗi nguyên liệu: Name, Quantity, Unit, Notes (tùy chọn), SortOrder. Điều kiện: Quantity > 0, Unit không rỗng, Name 1–100 ký tự.
- `POST/PUT/DELETE /api/v1/recipes/{id}/ingredients/{ingId?}` → 201/200/204.

#### FR-RCP-010: Quản lý Các bước Thực hiện (CRUD RecipeStep) (M)
- Mỗi bước: StepNumber (tự tăng), Description (không rỗng, tối đa 2000 ký tự), DurationMinutes (tùy chọn), ImageUrl (tùy chọn). **Khi xóa một bước, hệ thống tự động renumber các bước còn lại** để đảm bảo StepNumber liên tục (1, 2, 3…).
- `POST/PUT/DELETE /api/v1/recipes/{id}/steps/{stepId?}` → 201/200/204.

### 3.4. Module Tìm kiếm và Phân trang (FR-SRCH)

#### FR-SRCH-001: Tìm kiếm Toàn văn bản — Full-Text Search (M)
- FTS cho công thức với cấu hình tiếng Việt. SearchVector (computed/trigger) tự cập nhật khi Title/Description thay đổi. Xếp hạng bằng `ts_rank()`. Hỗ trợ tìm gần đúng với unaccent extension (bỏ dấu tiếng Việt: "pho" tìm được "phở").
- Luồng: xây tsquery từ search terms (prefix matching "pho:* & bo:*") → query FTS → chỉ Published → order by `ts_rank` DESC → trả `PagedResult<RecipeSummaryDto>` với field relevanceScore. Kết quả KHÔNG cache lâu (query đa dạng); cache ngắn 5 phút hoặc vary by query.
- Ngoại lệ: A1 query rỗng/<2 ký tự → 422; A2 không tìm thấy → 200 với items rỗng; A3 ký tự đặc biệt (SQL injection attempt) → parameterize tự động, sanitize tsquery.
- Endpoint: `GET /api/v1/recipes/search?q={searchTerm}&page={n}&pageSize={n}`.

#### FR-SRCH-002/003/004: Lọc, Sắp xếp, Phân trang (tóm tắt)

Tích hợp sẵn vào FR-RCP-001 và FR-SRCH-001:

| Mã FR | Tên | Tham số Query | Mô tả |
|---|---|---|---|
| FR-SRCH-002 | Lọc công thức | `categoryId, difficulty, maxCookTime, minServings` | Lọc kết hợp AND logic |
| FR-SRCH-003 | Sắp xếp kết quả | `sort={field}` VD: `sort=createdAt` (ASC), `sort=-createdAt` (DESC) | Tiền tố "-" = descending. Mặc định: `sort=-createdAt` |
| FR-SRCH-004 | Phân trang (Offset-based) | `page={n}` (default 1), `pageSize={n}` (default 12, max 50) | SKIP/TAKE; response gồm totalCount, totalPages, hasNextPage, hasPreviousPage |

### 3.5. Module Quản lý Tệp tin (FR-FILE)

Abstraction layer cho phép swap implementation (MinIO ↔ AWS S3 ↔ local filesystem) mà không đổi Application Layer.

| Mã FR | Tên | Mô tả | Ràng buộc kỹ thuật |
|---|---|---|---|
| FR-FILE-001 | Upload File lên MinIO | Upload → unique filename `{folder}/{uuid}{ext}` (chống path traversal) → trả public URL | Max 5MB. MIME JPEG/PNG/WebP/AVIF. Magic bytes validation. Bucket "culinary-blog". Policy public-read. |
| FR-FILE-002 | Xóa File khỏi MinIO | Trích object name từ URL, xóa. Thường gọi từ background job (fire-and-forget) khi xóa recipe | Object không tồn tại → không throw (idempotent). Lỗi kết nối MinIO → retry tối đa 3 lần. |

### 3.6. Module Background Jobs (FR-JOB)

Xử lý tác vụ nền không đồng bộ. 3 loại job: Fire-and-forget (chạy ngay), Delayed (chạy sau N giây/phút), Recurring (lịch cron).

| Mã FR | Tên Job | Loại | Trigger | Mô tả | Retry Policy |
|---|---|---|---|---|---|
| FR-JOB-001 | Welcome Email Job | Fire-and-forget | Sau FR-AUTH-001 thành công | Gửi email HTML chào mừng: tên người dùng, link kích hoạt email (nếu cần), link đến ứng dụng | Retry 3 lần, exponential backoff (1, 5, 30 phút). Sau 3 lần fail → Failed state, log error |
| FR-JOB-002 | Image Resize/Thumbnail Job | Fire-and-forget | Sau FR-RCP-008 upload ảnh thành công | Tạo thumbnail (300×300) và medium image (800×600) từ ảnh gốc. Lưu cả 3 phiên bản. Cập nhật URLs vào database | Retry 3 lần. Nếu fail: ảnh gốc vẫn hiển thị, chỉ thiếu thumbnail |
| FR-JOB-003 | Sitemap Generation Job | Recurring | Hàng ngày 02:00 AM UTC (cron `0 2 * * *`) | Tạo file sitemap.xml chứa URL tất cả Published recipes, categories, trang tĩnh. Upload lên MinIO/wwwroot. Ping Google Search Console | Retry 2 lần nếu fail. Log kết quả (số URL trong sitemap) |

### 3.7. Module Quan sát Hệ thống (FR-OBS)

3 trụ cột Observability: Logging, Metrics, Distributed Tracing. Bắt buộc cho production deployment.

| Mã FR | Tên | Mô tả | Kỹ thuật/Công cụ |
|---|---|---|---|
| FR-OBS-001 | Health Check Endpoints | 3 endpoint: `GET /health` (tổng hợp DB/Redis/MinIO), `GET /health/live` (liveness — chỉ process còn sống), `GET /health/ready` (readiness — DB/Redis sẵn sàng; fail → ngừng route traffic) | Health check libraries cho Postgres/Redis/MinIO |
| FR-OBS-002 | Structured Logging | Mọi HTTP request log với: CorrelationId (X-Correlation-Id header), method/path/status, elapsed time, UserId (khi xác thực). Log middleware/pipeline log mọi Command/Query. Performance alert khi request > 500ms | Structured logger + CorrelationId middleware. Sinks: Console (JSON), File (rolling daily), Seq (dev). Levels: Debug (dev), Info (prod), Warning/Error luôn |
| FR-OBS-003 | Distributed Tracing & Metrics | Instrumentation cho: HTTP request traces, DB operation traces, custom business metrics (recipe created/published count). Export tới Seq (dev) hoặc Jaeger/Grafana Tempo (prod) | OpenTelemetry SDK, OTLP exporter. TraceId include trong structured log |

---

## 4. Yêu cầu Phi Chức năng (NFR)

Mô hình ISO/IEC 25010 (FURPS+). Mỗi NFR có mã định danh, mức ưu tiên, tiêu chí đo lường định lượng.

| Mã NFR | Danh mục | Số yêu cầu | Ưu tiên |
|---|---|---|---|
| NFR-PERF | Hiệu năng | 5 | Cao |
| NFR-SEC | Bảo mật | 6 | Rất cao |
| NFR-USE | Khả năng sử dụng | 4 | Trung bình |
| NFR-REL | Độ tin cậy | 3 | Cao |
| NFR-MAINT | Khả năng bảo trì | 4 | Trung bình |
| NFR-SCALE | Khả năng mở rộng | 3 | Cao |
| NFR-SEO | Tối ưu SEO | 4 | Cao |

### 4.1. Hiệu năng (NFR-PERF)

Đo trong production với tải thực tế, cache warm (Redis hit rate ≥ 80%).

- **NFR-PERF-001 Response Time API**: p50 ≤ 150ms (GET với dữ liệu cache); p95 ≤ 500ms (mọi endpoint kể cả write); p99 ≤ 1000ms — không vượt 1 giây mọi trường hợp.
- **NFR-PERF-002 Throughput**: xử lý đồng thời ≥ 100 concurrent users không degradation trên 2 vCPU/4GB RAM (single instance); horizontal scaling thêm instance tuyến tính.
- **NFR-PERF-003 Cache Effectiveness**: Redis hit rate ≥ 80% steady-state. Category list TTL 30 phút; Recipe detail TTL 5 phút (cache-aside); Search results TTL 1 phút. Cache invalidation event-driven (xóa cache khi Create/Update/Delete).
- **NFR-PERF-004 Database Query**: không N+1 query problem (bắt buộc eager loading/projection). Mọi WHERE/ORDER BY column có index B-tree tương ứng. Slow query log cảnh báo khi query > 100ms.
- **NFR-PERF-005 Frontend Performance (Core Web Vitals)**: LCP ≤ 2.5s, CLS ≤ 0.1, INP ≤ 200ms, First Load JS Bundle ≤ 200KB (gzipped). Kỹ thuật: ISR, Image Optimization, Code Splitting.

### 4.2. Bảo mật (NFR-SEC)

Tuân thủ OWASP Top 10 (2021), kiểm thử qua security review trước khi release production.

- **NFR-SEC-001 Password & Hashing**: hash mật khẩu (bản gốc PBKDF2-HMACSHA512, iteration ≥100.000 → thực tế **argon2**). Không bao giờ lưu plaintext. Yêu cầu độ phức tạp: ≥8 ký tự, ≥1 hoa + 1 thường + 1 số + 1 ký tự đặc biệt.
- **NFR-SEC-002 JWT Token Security**: Access Token JWT HS256, TTL 15 phút, claim userId/email/roles/jti. Refresh Token 128-bit random bytes, hash SHA-256 trước khi lưu DB, TTL 7 ngày. Rotation: refresh token revoke ngay sau khi dùng, cấp token mới. Detection: token đã revoke bị dùng lại → revoke toàn bộ token family.
- **NFR-SEC-003 Rate Limiting**: giới hạn theo IP chống brute force/DDoS. Auth endpoints (`/auth/*`): 10 req/phút/IP. API chung: 100 req/phút/IP. Upload endpoints: 5 req/phút/IP. HTTP 429 khi vượt, kèm header `Retry-After`.
- **NFR-SEC-004 Input Validation & File Upload Security**: validate tại Application Layer TRƯỚC khi xử lý. SQL Injection: parameterized queries (không raw SQL với user input). XSS: input sanitization + Content-Security-Policy header. MIME Validation: đọc magic bytes (không tin Content-Type header). File size: kiểm tra trước khi buffer toàn bộ vào memory. Path Traversal: GUID-based filename generation (không dùng tên file của user).
- **NFR-SEC-005 HTTPS & CORS**: toàn bộ traffic qua HTTPS (TLS 1.2+). Nginx redirect HTTP → HTTPS, HSTS header (max-age=31536000). CORS: chỉ cho phép origin cấu hình sẵn (không wildcard `*`). Allowed origins: `http://localhost:3000` (dev), `https://domain.com` (prod). Cookie SameSite=Strict, Secure=true (nếu dùng cookie cho refresh token).
- **NFR-SEC-006 Authorization & Resource Ownership**: kiểm tra phân quyền tại Application Layer (không chỉ Presentation). Authorization Handler xác minh ResourceOwnership (Author chỉ xóa recipe của mình). Role-based policies không hardcode role string. Sensitive endpoints (DELETE, PATCH publish): double-check user ID trước khi commit. Audit trail: log mọi write operation với userId + timestamp.
- **NFR-SEC-007 Secrets Management**: không bao giờ commit secrets vào Git. Development: local secret manager. Production: environment variables (Docker Compose env_file / K8s Secrets). Rotation: khuyến nghị rotate JWT signing key mỗi 90 ngày. Scanning: pre-commit hook kiểm tra với truffleHog/gitleaks.

### 4.3. Khả năng Sử dụng (NFR-USE)

- **NFR-USE-001 Responsive Design**: Mobile 320–767px (single column, touch-friendly); Tablet 768–1199px (2-column grid); Desktop ≥1200px (full layout). Framework Tailwind CSS utility-first. Kiểm thử: Chrome DevTools responsive mode + BrowserStack.
- **NFR-USE-002 Accessibility (a11y)**: tuân thủ WCAG 2.1 Level AA. Semantic HTML5 (`<article>, <nav>, <main>, <aside>`). ARIA attributes. Keyboard navigation đầy đủ (Tab, Enter, Escape). Color contrast ratio ≥ 4.5:1 (text), ≥ 3:1 (UI components). Screen reader test với NVDA (Windows) và VoiceOver (macOS/iOS).
- **NFR-USE-003 Error Messages**: API trả RFC 7807 Problem Details `{type, title, status, detail, errors}`. Frontend hiển thị inline validation ngay bên cạnh field lỗi. Server errors (5xx) hiển thị thông báo thân thiện, không lộ stack trace. i18n-ready: error messages dùng error code (không hardcode tiếng Việt/Anh).
- **NFR-USE-004 Loading States**: mọi async operation phải có visual feedback: loading skeleton, optimistic update (rollback nếu fail), toast notification xác nhận thành công/thất bại, progress indicator cho upload ảnh (%) realtime.

### 4.4. Độ tin cậy (NFR-REL)

- **NFR-REL-001 Uptime SLA**: uptime ≥ 99.5% (≈3.65 giờ downtime/năm). Maintenance window công bố trước 48 giờ qua banner. Health check probe mỗi 10 giây. Monitoring: alert khi down > 1 phút.
- **NFR-REL-002 Error Handling & Resilience**: Global Exception Handler middleware bắt tất cả unhandled exceptions → trả 500 Problem Details + log. Database connection pool: tự reconnect, timeout 30s. Redis failover: nếu down → fallback database (không cache), không throw exception. Job retry: mỗi job tối đa 3 retry với exponential backoff. Circuit Breaker (tùy chọn nâng cao) cho external HTTP calls.
- **NFR-REL-003 Data Durability**: PostgreSQL WAL đảm bảo ACID. Backup tự động hàng ngày lúc 03:00 AM, lưu 30 ngày. MinIO: dữ liệu file trên volume persistent (không ephemeral container storage). Refresh tokens lưu DB (không Redis) để survive restart. Soft delete: Recipe đánh dấu IsDeleted thay vì xóa vật lý (có thể khôi phục).

### 4.5. Khả năng Bảo trì (NFR-MAINT)

- **NFR-MAINT-001 Code Quality**: code phải pass static analysis trước khi merge. TypeScript/React: ESLint (Airbnb ruleset), Prettier. Không compiler warnings trong build CI. Code review ≥1 reviewer phê duyệt PR.
- **NFR-MAINT-002 Test Coverage**: tối thiểu Unit tests ≥80% line coverage (commands, queries, validators). Integration tests: tất cả API endpoints có ít nhất 1 happy path + 1 error case. E2E tests: 5 critical user flows (register, login, create recipe, publish, search).
- **NFR-MAINT-003 Documentation**: README.md hướng dẫn setup dev environment (Docker Compose) trong <5 phút. API documentation tự sinh từ code (Swagger/OpenAPI). Architecture Decision Records (ADR): ghi lại mọi quyết định kiến trúc quan trọng. CHANGELOG.md cập nhật mỗi release (Keep a Changelog + SemVer).
- **NFR-MAINT-004 Clean Architecture Compliance**: tuân thủ nghiêm ngặt dependency rules. Domain layer: KHÔNG dependency vào bất kỳ layer nào khác. Application layer: chỉ depend vào Domain, KHÔNG reference Infrastructure. Infrastructure layer: depend vào Application (implements interfaces). Vi phạm được phát hiện qua architecture test project. CQRS: Commands thay đổi state, Queries đọc data — không trộn lẫn.

### 4.6. Khả năng Mở rộng (NFR-SCALE)

- **NFR-SCALE-001 Stateless Backend**: API thiết kế stateless để hỗ trợ horizontal scaling. JWT authentication (không session server-side). Distributed cache (Redis, không in-memory cache) cho mọi shared state. Distributed lock (RedLock) cho tác vụ singleton (sitemap generation). Job worker chạy với multiple workers, PostgreSQL/Redis làm shared queue.
- **NFR-SCALE-002 Database Scaling**: connection pooling (max 100 connections/instance). Read replica (tùy chọn) cho query routing. Index strategy: B-tree cho equality/range, GIN cho full-text search (tsvector). Table partitioning (nâng cao): partition Recipe by CreatedAt khi > 1 triệu rows.
- **NFR-SCALE-003 Infrastructure Scaling**: hạ tầng scale theo chiều ngang: Docker mỗi service là container riêng biệt (API, Postgres, Redis, MinIO, Nginx). Nginx load balancer upstream pool cho nhiều API instances. MinIO Distributed Mode (4+ nodes) cho production storage scaling. CDN cho static assets (Cloudflare).

### 4.7. Tối ưu SEO (NFR-SEO)

- **NFR-SEO-001 Structured Data**: mỗi trang công thức nấu ăn phải có JSON-LD Schema.org Recipe markup: `@type: "Recipe"`, thuộc tính name/description/image/author/datePublished/prepTime/cookTime/totalTime/recipeYield/recipeIngredient[]/recipeInstructions[]/nutrition. Validate: Google Rich Results Test — phải pass 100%. Kết quả: Rich Snippets trên Google Search (star rating, time, ingredients).
- **NFR-SEO-002 Meta Tags & Open Graph**: mỗi trang có đầy đủ `<title>: "{Recipe Name} | Culinary Blog"` (≤60 ký tự), `<meta name="description">` (150–160 ký tự), Open Graph (og:title, og:description, og:image 1200×630px, og:url, og:type), Twitter Card summary_large_image, Canonical URL (tránh duplicate content), Robots: index/follow (published) | noindex (draft/archived).
- **NFR-SEO-003 Sitemap & Robots**: sitemap XML tự động (sinh bởi FR-JOB-003, hàng ngày 02:00 AM UTC). Bao gồm tất cả Published recipes + category pages + trang tĩnh. Format sitemap.xml chuẩn có `<loc>, <lastmod>, <changefreq>, <priority>`. Robots.txt cho phép tất cả crawlers, khai báo Sitemap URL. Ping Google Search Console sau khi update sitemap.
- **NFR-SEO-004 URL Structure**: URL thân thiện SEO. Recipes: `/recipes/{slug}` — slug chữ thường, gạch nối, không dấu. Categories: `/categories/{slug}`. Slug generation tự động từ title, unique, không thay đổi sau khi publish. Redirect: nếu slug thay đổi (draft) → 301 redirect từ slug cũ sang slug mới. Không dùng query params cho nội dung chính (chỉ dùng cho filter/sort/pagination).

---

## 5. Yêu cầu Giao diện Ngoài

Mọi giao tiếp qua HTTPS (TLS 1.2+) trong production.

### 5.1. Giao diện Người dùng (UI)

Giao diện web duy nhất trên Next.js App Router, hoạt động như SPA với SSR và ISR.

| Màn hình / Route | Mô tả | Loại Rendering | Yêu cầu Auth |
|---|---|---|---|
| `/` | Trang chủ: recipe nổi bật + categories | ISR (revalidate=3600) | Không |
| `/recipes` | Danh sách tất cả recipes với filter/sort/search | SSR (dynamic) | Không |
| `/recipes/[slug]` | Chi tiết recipe: ingredients, steps, nutrition, JSON-LD | ISR (revalidate=300) | Không |
| `/categories` | Danh sách category | ISR (revalidate=3600) | Không |
| `/categories/[slug]` | Danh sách recipe theo category | ISR (revalidate=600) | Không |
| `/auth/login` | Form đăng nhập (email/password + Google OAuth) | CSR | Không (redirect nếu đã login) |
| `/auth/register` | Form đăng ký tài khoản mới | CSR | Không |
| `/dashboard` | Trang tổng quan của Author/Admin | CSR | Bắt buộc (Author/Admin) |
| `/dashboard/recipes` | Quản lý danh sách recipe của user | CSR | Bắt buộc |
| `/dashboard/recipes/new` | Form tạo recipe mới (multi-step wizard) | CSR | Bắt buộc (Author/Admin) |
| `/dashboard/recipes/[id]/edit` | Form chỉnh sửa recipe | CSR | Bắt buộc (Owner/Admin) |
| `/dashboard/categories` | Quản lý categories | CSR | Bắt buộc (Admin) |
| `/profile` | Xem và chỉnh sửa thông tin cá nhân | CSR | Bắt buộc |
| `/search` | Trang kết quả full-text search | SSR | Không |

### 5.2. Giao diện Phần mềm – REST API

| Thuộc tính | Giá trị |
|---|---|
| Giao thức | HTTP/1.1 và HTTP/2 qua HTTPS (TLS 1.2+). Nginx termination SSL |
| Base URL (dev) | `http://localhost:5000/api/v1` |
| Base URL (prod) | `https://api.culinaryblog.com/api/v1` |
| Content-Type | `application/json; charset=utf-8`. Multipart/form-data cho upload |
| Authentication | Bearer Token trong Authorization header: `Authorization: Bearer <access_token>`. Refresh token trong request body (không dùng cookie, tránh CSRF) |
| Response Format | Success: `{"data": {...}, "meta": {"page":1,"pageSize":10,"total":100}}`. Error: RFC 7807 Problem Details `{"type","title","status","detail","errors":{}}` |
| Versioning | URL Path versioning `/api/v1/` (breaking changes → `/api/v2/`, v1 duy trì tối thiểu 6 tháng) |
| CORS Headers | `Access-Control-Allow-Origin: <configured-origins>`, `-Methods: GET,POST,PUT,PATCH,DELETE,OPTIONS`, `-Headers: Content-Type, Authorization, X-Correlation-ID` |
| Rate Limit Headers | `X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset` (Unix timestamp), `Retry-After` (giây, khi 429) |
| Correlation ID | `X-Correlation-ID` header: sinh tự động nếu không có trong request, trả về trong response, gán vào tất cả log entries |

### 5.3. Giao diện Dịch vụ Bên thứ ba

| Dịch vụ | Mục đích | Giao thức/SDK |
|---|---|---|
| Google OAuth 2.0 | Đăng nhập/đăng ký bằng tài khoản Google | OAuth 2.0 Authorization Code + PKCE. Redirect URI: `/api/v1/auth/google/callback`. Scopes: openid, email, profile |
| MinIO (S3-compatible) | Lưu trữ file ảnh công thức | S3 SDK. Endpoint override cho MinIO. Presigned URL cho direct browser upload (optional) |
| Background Job Queue | Background job processing | In-process/queue server. Dashboard quản lý jobs (Admin only, policy-protected) |
| Structured Logging + Log Aggregation | Structured logging & log aggregation | Console (JSON), File sink, HTTP ingest API |
| OpenTelemetry | Distributed tracing & metrics | OTLP exporter. Tracing: HttpClient, DB, API framework |
| SMTP / Email | Gửi welcome email (FR-JOB-001) | SMTP với TLS. Development: Mailhog (fake SMTP) |
| Google Search Console | Ping sitemap update | HTTP GET `https://www.google.com/ping?sitemap={url}`. Không cần API key |

### 5.4. Giao diện Phần cứng

Web application, không giao tiếp trực tiếp với phần cứng chuyên biệt.

| Thành phần | Development (local) | Production (minimum) |
|---|---|---|
| CPU | 2 cores | 2 vCPU (VPS/Cloud instance, x86_64) |
| RAM | 8 GB (Docker Compose đầy đủ: API + PG + Redis + MinIO + Seq) | 4 GB |
| Storage | 20 GB SSD | 50 GB SSD (production data growth) |
| Network | Kết nối internet (npm/package, Google OAuth) | Bandwidth ≥ 1 Gbps, IP tĩnh |
| Browser Client | Chrome 112+, Firefox 113+, Safari 16+, Edge 112+ (ES2020+) | Tương tự — không hỗ trợ IE11 |

---

## 6. Kiến trúc Hệ thống

Client-Server, hai tầng riêng biệt (Frontend Next.js, Backend API), giao tiếp qua REST API. Backend tuân thủ Clean Architecture kết hợp CQRS pattern (`@nestjs/cqrs` trong stack thực tế).

### 6.1. Tổng quan Kiến trúc

| Tầng | Vai trò | Giao tiếp với |
|---|---|---|
| Client (Browser/Mobile) | Người dùng tương tác qua giao diện web | Next.js App |
| Frontend | Rendering UI, route management, client-side state. SSR/ISR cho SEO | Backend REST API |
| Nginx Reverse Proxy | SSL termination, load balancing, static file caching, rate limiting basic | Frontend :3000, Backend API :5000 |
| Backend API | Business logic, authentication, data access, background jobs | PostgreSQL, Redis, MinIO, Email |
| Cache Layer | Distributed cache cho recipe/category/search results | Backend API |
| Object Storage | Lưu file ảnh: original, medium (800×600), thumbnail (300×300) | Backend API (S3 SDK) |
| Database | Persistent relational data storage. Full-text search via tsvector | Backend API (ORM) |
| Observability | Logging, metrics, distributed tracing | Backend API |

### 6.2. Kiến trúc Backend – Clean Architecture

Dependency Rule: dependency chỉ đi vào trong (hướng Domain). Không bao giờ có reference từ Domain/Application ra Infrastructure.

| Layer | Nội dung |
|---|---|
| **Domain** | Nhân lõi hệ thống. Entities: Recipe, Category, ApplicationUser, RecipeStep, RecipeIngredient, RecipeImage. Value Objects: Slug, EmailAddress. Owned Entities: RecipeNutrition. Domain Events (optional). Enums: RecipeDifficulty, RecipeStatus. Interfaces: repositories. Không dependency ngoài (chỉ BCL). |
| **Application** | Orchestration Layer. Commands (CQRS write): CreateRecipeCommand, PublishRecipeCommand, LoginCommand... Queries (CQRS read): GetRecipesQuery, GetRecipeBySlugQuery... Handlers xử lý business logic. DTOs/Response models. Validators (rules cho mỗi command). Pipeline Behaviors: ValidationBehavior, LoggingBehavior, CachingBehavior, PerformanceBehavior. Service interfaces: IEmailService, IJwtService, IFileStorageService, ICurrentUser. |
| **Infrastructure** | Implements application interfaces. DB context, configurations, migrations. Repository implementations (LINQ/query builder + FTS). JWT Service. File Storage: MinioFileStorageService. Email: EmailService. Cache: RedisCacheService. Job registrations. Interceptors: AuditInterceptor (auto set CreatedAt/UpdatedAt). |
| **Presentation** | HTTP interface. Endpoint Groups: AuthEndpoints, RecipesEndpoints, CategoriesEndpoints. Middleware: GlobalExceptionMiddleware, CorrelationIdMiddleware, RateLimitingMiddleware. DI Configuration. OpenAPI/Scalar UI. Authentication: JWT Bearer + Google OAuth. |

### 6.3. CQRS + Pipeline

CQRS tách biệt read và write models. Mỗi request đi qua pipeline behaviors theo thứ tự:

| Thứ tự | Pipeline Behavior | Trách nhiệm | Áp dụng cho |
|---|---|---|---|
| 1 | LoggingBehavior | Log request type, parameters, elapsed time. Cảnh báo nếu > 500ms | Tất cả Commands và Queries |
| 2 | ValidationBehavior | Chạy validators đã đăng ký. Throw ValidationException nếu có lỗi | Tất cả Commands/Queries có Validator |
| 3 | CachingBehavior | Kiểm tra cache trước khi xử lý (implements ICacheable) | Queries (GET endpoints) |
| 4 | Handler | Thực thi business logic: gọi repositories, raise domain events, tạo response DTO | Tất cả (bắt buộc) |
| 5 | CacheInvalidationBehavior | Xóa cache liên quan sau khi Command thành công (implements ICacheInvalidator) | Commands thay đổi data (Create/Update/Delete) |

### 6.4. Mô hình Quan hệ Thực thể (ERD tóm tắt)

PostgreSQL 16, ORM Code First. Tất cả entities kế thừa BaseEntity (Id, CreatedAt, UpdatedAt, IsDeleted, RowVersion).

| Thực thể | Quan hệ | Bảng PostgreSQL |
|---|---|---|
| Recipe | 1:N RecipeStep, 1:N RecipeIngredient, 1:N RecipeImage, 1:1 (Owned) RecipeNutrition, N:1 Category, N:1 Author/ApplicationUser | Recipes, RecipeSteps, RecipeIngredients, RecipeImages (owned — cột trong Recipes), Categories, AspNetUsers |
| ApplicationUser | 1:N Recipe (Author), 1:N RefreshToken | AspNetUsers (Identity), RefreshTokens |
| Category | 1:N Recipe | Categories |
| RefreshToken | N:1 ApplicationUser | RefreshTokens |

### 6.5. Triển khai – Docker Compose

Toàn bộ hệ thống containerized. Dev dùng `docker-compose.yml`, Production dùng `docker-compose.prod.yml` với optimized build + secrets management.

| Service | Port (host:container) | Volume/Dependency |
|---|---|---|
| nginx | 80:80, 443:443 | Depends: api, frontend. Volume: `./nginx/nginx.conf`, `./ssl/` |
| api | 5000:8080 | Depends: postgres, redis, minio. Env file `.env.production` |
| frontend | 3000:3000 | Depends: api |
| postgres | 5432:5432 | Volume `pgdata:/var/lib/postgresql/data`. Env: DB/USER/PASSWORD |
| redis | 6379:6379 | Volume `redisdata:/data`. Command: `redis-server --appendonly yes` |
| minio | 9000:9000, 9001:9001 (Console) | Volume `miniodata:/data`. Command: `server /data --console-address :9001` |
| seq (log aggregation) | 5341:80 | Volume `seqdata:/data`. Dev only — không deploy production |
| mailhog | 8025:8025 (UI), 1025:1025 (SMTP) | Dev only — test email |

---

## 7. Mô hình Dữ liệu

Tất cả entities kế thừa BaseEntity và dùng Soft Delete pattern (`IsDeleted` flag). Database: PostgreSQL 16.

### 7.1. BaseEntity (Abstract)

Không tạo bảng riêng — mỗi entity có bảng riêng với các cột kế thừa.

| Column | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| Id | uuid | PRIMARY KEY, `gen_random_uuid()` | Khóa chính UUID v4 — tránh sequential ID guessing |
| CreatedAt | timestamptz | NOT NULL, DEFAULT NOW() | Thời điểm tạo bản ghi (audit interceptor) |
| UpdatedAt | timestamptz | NULL | Thời điểm cập nhật cuối |
| IsDeleted | boolean | NOT NULL, DEFAULT false | Soft delete flag. Global Query Filter `.Where(x => !x.IsDeleted)` |
| RowVersion | bytea (timestamp) | NOT NULL, Concurrency Token | Optimistic concurrency control |

### 7.2. Recipe

Thực thể trung tâm. Một Recipe thuộc một Category và một Author. Chứa Owned Entity RecipeNutrition và các Collection Navigation Properties.

| Column | Kiểu | Ràng buộc | Index | Mô tả |
|---|---|---|---|---|
| Id | uuid | PK (kế thừa) | PK | |
| Title | varchar(200) | NOT NULL | GIN trigram (optional) | Tiêu đề. Unique không bắt buộc |
| Slug | varchar(220) | NOT NULL, UNIQUE | UNIQUE B-tree | URL-friendly, sinh từ Title + chuẩn hóa. Không đổi sau Publish |
| Description | text | NOT NULL | — | Mô tả ngắn (≤2000 ký tự) |
| Instructions | text | NOT NULL | — | Hướng dẫn tổng quan dạng markdown (legacy field). Chi tiết dùng RecipeSteps |
| PrepTime | integer | NOT NULL, CHECK > 0 | — | Thời gian chuẩn bị (phút) |
| CookTime | integer | NOT NULL, CHECK ≥ 0 | — | Thời gian nấu (phút). 0 cho "No cook" |
| Servings | integer | NOT NULL, CHECK > 0 | — | Số khẩu phần |
| Difficulty | smallint (enum) | NOT NULL, DEFAULT 1 | idx | 1=Easy, 2=Medium, 3=Hard, 4=Expert |
| Status | smallint (enum) | NOT NULL, DEFAULT 0 | idx | 0=Draft, 1=Published, 2=Archived |
| CategoryId | uuid | NOT NULL, FK → Categories.Id, ON DELETE RESTRICT | B-tree | Không xóa category có recipe |
| AuthorId | varchar(450) | NOT NULL, FK → AspNetUsers.Id | B-tree | |
| SearchVector | tsvector | NULL | GIN | Full-text search vector, tự cập nhật bởi PostgreSQL TRIGGER, dùng unaccent cho tiếng Việt |
| PublishedAt | timestamptz | NULL | idx | Set khi Status → Published |
| CreatedAt / UpdatedAt / IsDeleted / RowVersion | (BaseEntity) | | | |

#### 7.2.1. RecipeNutrition (Owned Entity — cột trong bảng Recipes)

Không có bảng riêng. Các cột nhúng trực tiếp vào bảng Recipes với tiền tố `Nutrition_`.

| Column trong DB | Property | Kiểu | Mô tả |
|---|---|---|---|
| Nutrition_Calories | Calories | decimal(8,2)? | Năng lượng (kcal/serving). Nullable |
| Nutrition_Protein | Protein | decimal(8,2)? | Đạm (gram/serving). Nullable |
| Nutrition_Carbohydrates | Carbohydrates | decimal(8,2)? | Tinh bột (gram/serving). Nullable |
| Nutrition_Fat | Fat | decimal(8,2)? | Chất béo (gram/serving). Nullable |
| Nutrition_Fiber | Fiber | decimal(8,2)? | Chất xơ (gram/serving). Nullable |
| Nutrition_Sodium | Sodium | decimal(8,2)? | Natri (mg/serving). Nullable |

### 7.3. RecipeStep

Các bước thực hiện chi tiết của một Recipe, sắp xếp theo StepNumber.

| Column | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| Id | uuid | PK | |
| RecipeId | uuid | NOT NULL, FK → Recipes.Id, ON DELETE CASCADE | Xóa Recipe → xóa tất cả Steps |
| StepNumber | integer | NOT NULL, CHECK > 0 | Thứ tự bước. UNIQUE cùng RecipeId (composite unique) |
| Title | varchar(200) | NOT NULL | Tên bước ngắn gọn |
| Description | text | NOT NULL | Mô tả chi tiết bước thực hiện |
| TimerMinutes | integer | NULL, CHECK ≥ 0 | Thời gian cần cho bước. NULL nếu không áp dụng |
| ImageUrl | varchar(500) | NULL | URL ảnh minh họa bước (trên MinIO) |

### 7.4. RecipeIngredient

| Column | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| Id | uuid | PK | |
| RecipeId | uuid | NOT NULL, FK → Recipes.Id, ON DELETE CASCADE | |
| Name | varchar(200) | NOT NULL | Tên nguyên liệu |
| Quantity | decimal(10,3) | NULL | Số lượng. Nullable cho "vừa đủ" |
| Unit | varchar(50) | NULL | Đơn vị đo lường (gram, ml, thìa canh, quả...) |
| Notes | varchar(500) | NULL | Ghi chú tùy chọn |
| OrderIndex | integer | NOT NULL, DEFAULT 0 | Thứ tự hiển thị |

### 7.5. RecipeImage

| Column | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| Id | uuid | PK | |
| RecipeId | uuid | NOT NULL, FK → Recipes.Id, ON DELETE CASCADE | |
| OriginalUrl | varchar(500) | NOT NULL | URL ảnh gốc trên MinIO |
| MediumUrl | varchar(500) | NULL | URL ảnh medium 800×600 (sinh bởi FR-JOB-002) |
| ThumbnailUrl | varchar(500) | NULL | URL ảnh thumbnail 300×300 (sinh bởi FR-JOB-002) |
| AltText | varchar(200) | NULL | Alt text cho accessibility |
| IsPrimary | boolean | NOT NULL, DEFAULT false | Ảnh chính (hiển thị đầu tiên). Chỉ 1 ảnh IsPrimary=true/Recipe |
| OrderIndex | integer | NOT NULL, DEFAULT 0 | Thứ tự hiển thị gallery |

### 7.6. Category

| Column | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| Id | uuid | PK | |
| Name | varchar(100) | NOT NULL, UNIQUE | Tên danh mục |
| Slug | varchar(120) | NOT NULL, UNIQUE | URL-friendly, sinh từ Name |
| Description | text | NULL | Mô tả danh mục |
| ImageUrl | varchar(500) | NULL | URL ảnh đại diện category |
| OrderIndex | integer | NOT NULL, DEFAULT 0 | Thứ tự hiển thị trên navigation |

### 7.7. ApplicationUser (extends IdentityUser)

Bảng "AspNetUsers". Cột custom thêm vào:

| Column (custom) | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| DisplayName | varchar(100) | NOT NULL | Tên hiển thị công khai (khác username) |
| AvatarUrl | varchar(500) | NULL | URL ảnh avatar. Sinh từ Google Avatar khi đăng ký OAuth |
| Bio | text | NULL | Tiểu sử ngắn tác giả |
| IsActive | boolean | NOT NULL, DEFAULT true | Trạng thái tài khoản. Admin có thể deactivate user (ban) |
| CreatedAt | timestamptz | NOT NULL, DEFAULT NOW() | Ngày tạo tài khoản |

Identity columns kế thừa: Id (varchar 450), UserName, NormalizedUserName, Email, NormalizedEmail, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumber, TwoFactorEnabled, LockoutEnd, LockoutEnabled, AccessFailedCount.

### 7.8. RefreshToken

| Column | Kiểu | Ràng buộc | Mô tả |
|---|---|---|---|
| Id | uuid | PK | |
| UserId | varchar(450) | NOT NULL, FK → AspNetUsers.Id, ON DELETE CASCADE | Chủ sở hữu token |
| TokenHash | varchar(64) | NOT NULL, UNIQUE | **SHA-256 hash của raw token**. Không lưu raw token |
| ExpiresAt | timestamptz | NOT NULL | Thời hạn token (7 ngày kể từ CreatedAt) |
| RevokedAt | timestamptz | NULL | Thời điểm revoke. NULL = còn hiệu lực |
| ReplacedByTokenHash | varchar(64) | NULL | Hash của token mới (khi rotation). Trace token family |
| CreatedAt | timestamptz | NOT NULL, DEFAULT NOW() | Thời điểm tạo |
| CreatedByIp | varchar(45) | NULL | IP address tạo token. Lưu để audit |

---

## 8. Đặc tả REST API

Base URL: `/api/v1`. Tài liệu chi tiết (request/response schemas) sinh tự động qua Swagger/OpenAPI (`/scalar` trong bản gốc .NET, `/api-docs` trong stack thực tế NestJS).

**Convention**: HTTP Method + Path (prefixed `/api/v1`); `auth required` = Bearer JWT Access Token bắt buộc; `role` = Role tối thiểu cần thiết (Author ⊂ Admin).

**Pagination**: Query params `?page=1&pageSize=10&sortBy=createdAt&sortOrder=desc`. Response wrapper: `{"data":[], "meta":{"page","pageSize","total","totalPages"}}`.

**Error Format**: RFC 7807 Problem Details: `{"type":"about:blank","title":"...","status":400,"detail":"...","errors":{"field":["msg"]}}`.

> ⚠️ Endpoint auth cụ thể (register/login/google/refresh/logout/me) đã được override theo `manifest`/`CLAUDE.md` (§ Auth API) — dùng bản đó làm chuẩn khi có khác biệt field name.

### 8.1. Authentication Module (/auth)

| Method | Endpoint | Mô tả | Auth | Request Body/Params | Response |
|---|---|---|---|---|---|
| POST | `/auth/register` | Đăng ký tài khoản mới | Không | `{email, password, displayName}` | 201: `{userId, email, displayName}`; 400 validation; 409 email đã tồn tại |
| POST | `/auth/login` | Đăng nhập email/password | Không | `{email, password}` | 200: `{accessToken, refreshToken, expiresIn}`; 401 sai credentials; 429 rate limit |
| POST | `/auth/google` | Đăng nhập Google OAuth | Không | `{idToken}` | 200: `{accessToken, refreshToken, expiresIn}`; 400 invalid token |
| POST | `/auth/refresh` | Làm mới Access Token | Không (dùng refreshToken) | `{refreshToken}` | 200: `{accessToken, refreshToken, expiresIn}`; 401 token hết hạn/bị revoke |
| POST | `/auth/logout` | Đăng xuất, revoke refresh token | Bearer JWT | `{refreshToken}` | 204 No Content; 401 Unauthorized |
| GET | `/auth/me` | Lấy thông tin user hiện tại | Bearer JWT | — | 200: `{id, email, displayName, avatarUrl, bio, roles}`; 401 |
| PATCH | `/auth/me` | Cập nhật profile người dùng | Bearer JWT | `{displayName?, avatarUrl?, bio?}` | 200: profile mới; 400 validation; 401 |

### 8.2. Categories Module (/categories)

| Method | Endpoint | Mô tả | Auth/Role | Request | Response |
|---|---|---|---|---|---|
| GET | `/categories` | Lấy danh sách tất cả categories | Không | — | 200: `[{id, name, slug, description, imageUrl, recipeCount}]` |
| GET | `/categories/{slug}` | Chi tiết category + danh sách recipes | Không | `?page=1&pageSize=10&sortBy=...` | 200: `{category, recipes: PagedResult}`; 404 Category not found |
| POST | `/categories` | Tạo category mới | Bearer + Admin | `{name, description?, imageUrl?}` | 201: `{id, name, slug, description}`; 400 validation; 403 Forbidden; 409 name đã tồn tại |
| PUT | `/categories/{id}` | Cập nhật category | Bearer + Admin | `{name, description?, imageUrl?, orderIndex?}` | 200: category updated; 400/403/404 |
| DELETE | `/categories/{id}` | Xóa category (soft delete) | Bearer + Admin | — | 204 No Content; 403 Forbidden; 404 Not found; 409 còn recipes thuộc category |

### 8.3. Recipes Module (/recipes)

| Method | Endpoint | Mô tả | Auth/Role | Request |
|---|---|---|---|---|
| GET | `/recipes` | Danh sách recipes (Published, paginated) | Không | `?page&pageSize&sortBy&sortOrder&categoryId&difficulty&maxCookTime` |
| GET | `/recipes/{slug}` | Chi tiết recipe (kèm steps, ingredients, images, nutrition) | Không (Draft: Author/Admin) | — |
| GET | `/recipes/search` | Full-text search công thức | Không | `?q={keyword}&page&pageSize&categoryId...` |
| POST | `/recipes` | Tạo recipe mới (trạng thái Draft) | Bearer (Author/Admin) | `{title, description, categoryId, prepTime, cookTime, servings, difficulty, instructions?, nutrition?, steps?, ingredients?}` |
| PUT | `/recipes/{id}` | Cập nhật thông tin cơ bản recipe | Bearer (Owner/Admin) | `{title?, description?, categoryId?, prepTime?, cookTime?, servings?, difficulty?, instructions?, nutrition?}` |
| PATCH | `/recipes/{id}/publish` | Publish recipe (Draft → Published) | Bearer (Owner/Admin) | — |
| PATCH | `/recipes/{id}/unpublish` | Unpublish recipe (Published → Draft) | Bearer (Owner/Admin) | — |
| PATCH | `/recipes/{id}/archive` | Archive recipe | Bearer (Owner/Admin) | — |
| DELETE | `/recipes/{id}` | Xóa recipe (hard delete + cascade) | Bearer (Owner/Admin) | — |

### 8.4. Recipe Images (/recipes/{id}/images)

| Method | Endpoint | Mô tả | Auth | Request | Response |
|---|---|---|---|---|---|
| POST | `/recipes/{id}/images` | Upload ảnh mới cho recipe | Bearer (Owner/Admin) | multipart/form-data: `file` (image), `altText?`, `isPrimary?` | 201: `{imageId, originalUrl, altText, isPrimary}`; 400 MIME invalid/size>5MB; 403/404 |
| PATCH | `/recipes/{id}/images/{imageId}` | Cập nhật metadata ảnh | Bearer (Owner/Admin) | `{altText?, isPrimary?, orderIndex?}` | 200 image updated; 403/404 |
| DELETE | `/recipes/{id}/images/{imageId}` | Xóa ảnh (MinIO file xóa async) | Bearer (Owner/Admin) | — | 204 No Content; 403/404 |

### 8.5. Recipe Steps (/recipes/{id}/steps)

| Method | Endpoint | Mô tả | Auth | Request | Response |
|---|---|---|---|---|---|
| POST | `/recipes/{id}/steps` | Thêm bước mới vào recipe | Bearer (Owner/Admin) | `{stepNumber, title, description, timerMinutes?, imageUrl?}` | 201: RecipeStepDto; 400/403/404 |
| PUT | `/recipes/{id}/steps/{stepId}` | Cập nhật một bước | Bearer (Owner/Admin) | `{stepNumber?, title?, description?, timerMinutes?, imageUrl?}` | 200: RecipeStepDto; 400/403/404 |
| DELETE | `/recipes/{id}/steps/{stepId}` | Xóa một bước (auto renumber) | Bearer (Owner/Admin) | — | 204 No Content; 403/404 |

### 8.6. Recipe Ingredients (/recipes/{id}/ingredients)

| Method | Endpoint | Mô tả | Auth | Request | Response |
|---|---|---|---|---|---|
| POST | `/recipes/{id}/ingredients` | Thêm nguyên liệu | Bearer (Owner/Admin) | `{name, quantity?, unit?, notes?, orderIndex?}` | 201: RecipeIngredientDto; 400/403/404 |
| PUT | `/recipes/{id}/ingredients/{ingId}` | Cập nhật nguyên liệu | Bearer (Owner/Admin) | `{name?, quantity?, unit?, notes?, orderIndex?}` | 200: RecipeIngredientDto; 400/403/404 |
| DELETE | `/recipes/{id}/ingredients/{ingId}` | Xóa nguyên liệu | Bearer (Owner/Admin) | — | 204 No Content; 403/404 |

### 8.7. Health Check Endpoints

| Method | Endpoint | Mô tả | Auth | Response |
|---|---|---|---|---|
| GET | `/health` | Tổng hợp health tất cả dependencies (DB, Redis, MinIO) | Không | 200: `{status:"Healthy", entries:{database:{status:"Healthy"}, ...}}`; 503: Unhealthy |
| GET | `/health/live` | Liveness probe — chỉ kiểm tra process còn sống | Không | 200: Healthy (luôn, trừ khi process crashed) |
| GET | `/health/ready` | Readiness probe — kiểm tra DB và Redis sẵn sàng | Không | 200: Healthy (DB + Redis up); 503: Unhealthy (không nhận traffic) |

---

## Phụ lục A – HTTP Status Codes

| Code | Status | Ngữ cảnh sử dụng |
|---|---|---|
| 200 | OK | GET request thành công; PATCH trả về resource đã cập nhật; POST /auth/login thành công |
| 201 | Created | POST tạo resource mới thành công (Recipe, Category, Step, Ingredient, Image). Response body chứa resource vừa tạo |
| 204 | No Content | DELETE thành công; POST /auth/logout thành công. Không có response body |
| 400 | Bad Request | Validation lỗi, request body malformed, file MIME không hợp lệ, business rule vi phạm (vd: publish recipe thiếu ingredients) |
| 401 | Unauthorized | Access Token thiếu hoặc invalid; Refresh Token hết hạn/bị revoke |
| 403 | Forbidden | Đã xác thực nhưng không có quyền: Author truy cập endpoint Admin; Author cố xóa recipe của người khác |
| 404 | Not Found | Resource không tồn tại hoặc đã soft-delete (IsDeleted=true) |
| 409 | Conflict | Trùng lặp unique field (email đã đăng ký, category slug đã tồn tại); xóa category đang có recipes |
| 422 | Unprocessable Entity | Dữ liệu hợp lệ về cú pháp nhưng không thể xử lý về ngữ nghĩa (vd: RowVersion conflict — Optimistic Concurrency) |
| 429 | Too Many Requests | Rate limit bị vượt. Response kèm header `Retry-After` (giây) |
| 500 | Internal Server Error | Lỗi không xử lý được (unhandled exception). Trả RFC 7807, log đầy đủ. Không lộ stack trace |
| 503 | Service Unavailable | Health check failed (DB/Redis down); hoặc server overloaded |

## Phụ lục B – Application Error Codes

Hệ thống dùng Application Error Codes (mã lỗi tùy chỉnh) trong trường RFC 7807 `type` để frontend xử lý lỗi theo programmatic way, không phụ thuộc chuỗi message (có thể đổi theo locale).

| Error Code | HTTP Status | Mô tả | Module |
|---|---|---|---|
| `AUTH_EMAIL_EXISTS` | 409 | Email đã được đăng ký bởi tài khoản khác | Auth |
| `AUTH_INVALID_CREDENTIALS` | 401 | Email hoặc mật khẩu không đúng (generic — không tiết lộ email tồn tại hay không) | Auth |
| `AUTH_TOKEN_EXPIRED` | 401 | Access Token đã hết hạn (15 phút) | Auth |
| `AUTH_TOKEN_INVALID` | 401 | Access Token sai định dạng hoặc chữ ký không hợp lệ | Auth |
| `AUTH_REFRESH_TOKEN_EXPIRED` | 401 | Refresh Token đã hết hạn (7 ngày) | Auth |
| `AUTH_REFRESH_TOKEN_REVOKED` | 401 | Refresh Token đã bị thu hồi (reuse detection — log WARNING) | Auth |
| `AUTH_GOOGLE_TOKEN_INVALID` | 400 | Google ID Token không hợp lệ hoặc đã hết hạn | Auth |
| `AUTH_ACCOUNT_DISABLED` | 403 | Tài khoản bị vô hiệu hóa (IsActive=false) bởi Admin | Auth |
| `RECIPE_NOT_FOUND` | 404 | Recipe với id/slug không tồn tại hoặc đã bị xóa | Recipe |
| `RECIPE_SLUG_EXISTS` | 409 | Slug đã tồn tại — tự động thêm suffix (slug-1, slug-2...) | Recipe |
| `RECIPE_PUBLISH_INCOMPLETE` | 400 | Recipe thiếu điều kiện publish: phải có ít nhất 1 ingredient và 1 step | Recipe |
| `RECIPE_FORBIDDEN` | 403 | User không phải owner và không phải Admin | Recipe |
| `RECIPE_CONCURRENCY_CONFLICT` | 422 | RowVersion không khớp — resource đã được cập nhật bởi request khác. Client cần reload | Recipe |
| `CATEGORY_NOT_FOUND` | 404 | Category không tồn tại | Category |
| `CATEGORY_NAME_EXISTS` | 409 | Tên category đã tồn tại | Category |
| `CATEGORY_DELETE_HAS_RECIPES` | 409 | Không thể xóa category đang có recipes thuộc về | Category |
| `FILE_SIZE_EXCEEDED` | 400 | File upload vượt quá giới hạn 5MB | File |
| `FILE_MIME_INVALID` | 400 | Loại file không được phép. Chỉ chấp nhận JPEG, PNG, WebP, AVIF | File |
| `VALIDATION_ERROR` | 400 | Một hoặc nhiều field không hợp lệ. Xem `errors` object | Common |
| `RATE_LIMIT_EXCEEDED` | 429 | Quá giới hạn request. Xem `Retry-After` header | Common |

## Phụ lục C – Từ điển Thuật ngữ

| Thuật ngữ | Viết tắt | Định nghĩa |
|---|---|---|
| Access Token | AT | JSON Web Token (JWT) dùng để xác thực API request. TTL = 15 phút. Ký bằng HS256 |
| Application Error Code | AEC | Mã lỗi tùy chỉnh dạng SCREAMING_SNAKE_CASE trong trường "type" của RFC 7807 Problem Details |
| Archive | — | Trạng thái Recipe khi bị ẩn khỏi public listing nhưng không bị xóa. RecipeStatus.Archived |
| Author | — | Role người dùng mặc định sau khi đăng ký. Có thể tạo/quản lý recipe của mình |
| Background Job | — | Tác vụ xử lý bất đồng bộ chạy ngoài HTTP request cycle |
| Clean Architecture | CA | Kiến trúc phần mềm của Robert C. Martin tách biệt concerns theo layers (Domain, Application, Infrastructure, Presentation). Dependency chỉ đi vào trong (hướng Domain) |
| Command Query Responsibility Segregation | CQRS | Pattern tách biệt write model (Commands) và read model (Queries) để tối ưu từng luồng riêng |
| Content Delivery Network | CDN | Mạng phân phối nội dung tĩnh (ảnh, JS, CSS) từ server gần người dùng nhất |
| Core Web Vitals | CWV | Chỉ số đo lường UX của Google: LCP (tải trang), CLS (ổn định layout), INP (phản hồi tương tác) |
| Docker Compose | — | Công cụ định nghĩa và chạy multi-container Docker application qua file YAML |
| Draft | — | Trạng thái mặc định của Recipe khi mới tạo. Chỉ Author/Admin thấy |
| Full-Text Search | FTS | Tìm kiếm ngôn ngữ tự nhiên trong PostgreSQL qua tsvector/tsquery + unaccent extension |
| HTTP Status Code | — | Mã phản hồi HTTP chuẩn (RFC 7231) cho biết kết quả xử lý request (2xx thành công, 4xx client error, 5xx server error) |
| Incremental Static Regeneration | ISR | Tính năng Next.js tái sinh (regenerate) trang tĩnh theo chu kỳ (revalidate interval) thay vì build lại toàn bộ |
| JSON Web Token | JWT | Chuẩn mở (RFC 7519) định nghĩa cách truyền thông tin an toàn giữa các bên dưới dạng JSON object được ký |
| MinIO | — | Object storage server mã nguồn mở tương thích Amazon S3 API. Dùng để lưu trữ ảnh |
| Non-Functional Requirement | NFR | Yêu cầu chất lượng hệ thống: hiệu năng, bảo mật, độ tin cậy, khả năng bảo trì... |
| Nginx | — | Web server hiệu năng cao, dùng làm reverse proxy, load balancer và SSL termination |
| OpenTelemetry | OTEL | Framework quan sát hệ thống phân tán: distributed tracing, metrics, logs |
| Optimistic Concurrency | — | Kỹ thuật xử lý concurrent writes bằng RowVersion — không lock DB, phát hiện conflict khi save |
| Published | — | Trạng thái Recipe khi được công bố công khai. RecipeStatus.Published |
| Rate Limiting | — | Giới hạn số lượng request từ một IP trong khoảng thời gian nhất định để ngăn brute force/DDoS |
| Refresh Token | RT | Token dài hạn (7 ngày) dùng để lấy Access Token mới mà không cần đăng nhập lại |
| Refresh Token Rotation | — | Mỗi lần dùng Refresh Token để refresh → token cũ bị revoke, cấp token mới (bảo mật cao hơn) |
| Reuse Detection | — | Cơ chế phát hiện khi Refresh Token đã bị revoke được dùng lại → revoke toàn bộ token family của user |
| Slug | — | Chuỗi URL-friendly, dạng chữ-thường-gạch-nối, duy nhất, dùng để định danh Recipe/Category trên URL |
| Soft Delete | — | Đánh dấu `IsDeleted=true` thay vì xóa vật lý khỏi database. Dữ liệu có thể khôi phục |
| Software Requirements Specification | SRS | Tài liệu đặc tả yêu cầu phần mềm theo IEEE 830/ISO/IEC/IEEE 29148 |
| TanStack Query | — | Thư viện React quản lý server state: caching, background refetch, optimistic updates |
| tsvector / tsquery | — | Kiểu dữ liệu PostgreSQL cho full-text search. tsvector là chỉ mục đã xử lý, tsquery là biểu thức tìm kiếm |
| Unit of Work | UoW | Pattern đảm bảo nhiều operations được thực hiện trong một transaction duy nhất |
