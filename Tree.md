```tree
culinary-blog/
├── apps/
│   ├── backend/                      # NestJS API
│   │   ├── src/
│   │   │   ├── modules/              # Chia theo khối tính năng
│   │   │   │   ├── auth/             # Trang — FR-AUTH
│   │   │   │   ├── categories/       # Lành — FR-CAT + FR-SRCH
│   │   │   │   ├── recipes/          # Tuấn Anh — FR-RCP
│   │   │   │   └── media/            # Minh Tài — FR-FILE, FR-JOB, FR-OBS
│   │   │   ├── infrastructure/
│   │   │   │   ├── database/         # Drizzle schema, migrations
│   │   │   │   ├── cache/            # Redis service
│   │   │   │   ├── storage/          # MinIO/S3 service
│   │   │   │   └── jobs/             # BullMQ processors
│   │   │   └── common/
│   │   │       ├── filters/          # RFC 7807 exception filter
│   │   │       ├── interceptors/
│   │   │       ├── decorators/
│   │   │       └── guards/           # JWT, Roles guard
│   │   ├── drizzle/                  # Migration files
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   └── frontend/                     # Next.js App Router
│       ├── src/
│       │   ├── app/
│       │   │   ├── (auth)/           # Route group: login, register
│       │   │   ├── recipes/
│       │   │   ├── categories/
│       │   │   └── search/
│       │   ├── components/
│       │   └── lib/                  # API client, utils
│       ├── Dockerfile
│       ├── package.json
│       └── tsconfig.json
│
├── packages/
│   ├── shared/                       # Type dùng chung BE ↔ FE
│   │   ├── src/
│   │   │   ├── index.ts
│   │   │   └── types/
│   │   │       ├── auth.ts
│   │   │       ├── category.ts
│   │   │       ├── common.ts         # PagedResult, ProblemDetails
│   │   │       └── recipe.ts
│   │   └── package.json
│   └── config/
│       ├── tsconfig.base.json        # Config TS dùng chung
│       └── package.json
│
├── nginx/
│   └── nginx.conf
├── docker-compose.yml
├── .env.example
├── .gitignore
├── package.json                      # Script chạy toàn workspace
└── pnpm-workspace.yaml
```
