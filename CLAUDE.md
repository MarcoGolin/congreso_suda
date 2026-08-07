# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FlexTech congress/event management platform for IVCIUSMI / UNISUD (Paraguay). Features: attendee registration, QR check-in (morning/afternoon/workshop sessions), workshop inscription, scientific-paper submission, admin KPI dashboard, and sorteo (raffle). Monorepo with a Spring Boot WAR backend and a Flutter web-first frontend.

```
congreso_back_end/    # Spring Boot 3.1.12, Java 17, Maven, port 8081
congreso_frond_end/   # Flutter SDK ^3.8.0, pubspec name: congreso_evento
congreso.sql          # MySQL schema and seed data
```

---

## Backend — `congreso_back_end/`

**Stack:** Spring Boot 3.1.12 · Java 17 · Maven wrapper · WAR packaging · MySQL (`saas_congreso`)

### Commands
```bash
# Local dev (from congreso_back_end/)
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# Run all tests
./mvnw -Dspring.profiles.active=dev test

# Run a single test
./mvnw -Dtest=ClassName#methodName test

# Build WAR
./mvnw clean package                # or gerarwar.bat on Windows
./mvnw clean install                # fat jar — gerarFATjar.bat on Windows
```

**Profiles:** `dev` and `prod` — must be passed explicitly (no default active profile). Difference: log paths, Hibernate timezone. There is no `application-local.properties`.

### Architecture

**Root package:** `py.com.flextech` · Entry: `ServerApplication.java` (`@SpringBootApplication`, `@MapperScan("py.com.flextech.mapper")`, TZ forced to `America/Sao_Paulo`)

**Layered layout (one subpackage per business domain):**
- `controller/` — `@RestController`, all REST under `/api/<domain>` (no version prefix)
- `service/` — business logic
- `repository/` — Spring Data JPA repositories
- `mapper/` — MyBatis mapper interfaces; XMLs in `resources/mappers/<domain>/`
- `model/` — JPA entities + `dto/`
- `config/` — `security/`, `database/`, `cache/`, `i18n/`, `uazapi/`

**Persistence is hybrid — use the right layer for the job:**
- Spring Data JPA (Hibernate) for standard CRUD via `repository/`
- MyBatis + XML mappers for complex queries and reports via `mapper/` + `resources/mappers/`
- PageHelper for MySQL pagination (`pagehelper-spring-boot-starter`)
- `map-underscore-to-camel-case=true` in MyBatis config
- **DataSource is hardcoded in `config/database/DataBaseConfig.java`**, not in `application.properties`

**Security:** Spring Security + JWT (jjwt 0.10.5), stateless, BCrypt. Custom `JwtAuthenticationFilter`. Public endpoints: `/api/congresista/save`, `/api/auth/authenticate`, `/api/organizadores/consultaTodos`. All others require a Bearer token.

**Business domains:** `congresista` · `taller` (workshops) · `pago` / `habilitacion_pagos` · `checkin` · `trabajocientifico` · `sorteo` · `organizadores` · `sistema` · `dashboard` · `uazapi` (WhatsApp)

**External integrations:**
- Gmail SMTP (credentials in `application.properties`)
- uazapi — WhatsApp gateway via Spring WebFlux WebClient
- JasperReports + Apache POI + iText 5 + OpenCSV (reports/exports)
- FreeMarker templates (`resources/templates/`)
- Local filesystem storage (`image.directory`, `apk.directory` properties)

---

## Frontend — `congreso_frond_end/`

**Stack:** Flutter `^3.8.0` · Dart 3.8+ · Web primary (Windows also present) · MobX · flutter_modular · Dio · Supabase

### Commands
```bash
# From congreso_frond_end/
flutter pub get

# Codegen — run after every change to a model or MobX store
dart run build_runner build --delete-conflicting-outputs

# Dev
flutter run -d chrome

# Production build
flutter build web

# Regenerate launcher icons (after changing assets/icons)
dart run flutter_launcher_icons
```

**Note:** No tests exist yet. `flutter test` is wired but `test/` is empty.

### Architecture

**State management:** MobX — stores in `modules/*/stores/*.dart`, generated `*.g.dart` files. Per-page controllers named `*_ctrl.dart`.

**Routing / DI:** `flutter_modular` 6.4.1 — root `lib/app_module.dart` registers sub-modules. `AuthGuard` gates protected routes. `MaterialApp.router` + `Modular.routerConfig`.

**Per-module pattern:** `Page` (widget) → `Ctrl` (MobX) → `Service` → `Repository` (Dio). Dependencies wired via `i.addLazySingleton(X.new)` inside each `*_module.dart`.

**HTTP:** Dio in `lib/core/dio/api_rest_client.dart`. Base URL resolved in `lib/core/dio/hostname.dart` — hardcoded prod (`https://www.congresounisud.com:8444/congreso/api`) when `kReleaseMode`, otherwise reads from `.env` (`urlBaseDev`, `apiDev`, `portaDev`). Interceptor chain: Auth · Error · Language · TimeExecution · Connectivity · RetryOnConnectionChange · NoAuth. HTTP 401 auto-redirects to `/login`.

**Config:** `.env` at `congreso_frond_end/` root (declared as pubspec asset) loaded via `flutter_dotenv` in `main.dart`. Supabase URL is hardcoded in `main.dart`; anon key comes from `.env`.

**Assets:** Local under `assets/` — use **WebP** for all performance-critical images (hero, logo, speakers, sponsors). Remote CDN images (Supabase Storage) use `CachedNetworkImage`.

**Business modules** (`lib/modules/`): `auth` · `home` · `home_admin` · `home_congresista` · `inscripcion` · `talleres` · `checkin` · `sorteo` · `trabajo_cientifico` · `dashboard_admin` · `auspiciantes` · `disertante`

**Web (`web/index.html`):** `<base href="/">` · full SEO / OpenGraph / JSON-LD · custom splash `#preloader` removed on `flutter-first-frame` · deep-link rescue writes intended path to `sessionStorage['flutter_intended_route']` before redirecting to `/`.

---

## Production Server

**Server:** Contabo VPS `vmi2753744` · **IP:** `147.93.185.240` · **OS:** Ubuntu 24.04 LTS · **SSH alias:** `contabo_marco` (también `congreso`)

All deploy scripts assume the SSH alias `contabo_marco` is configured in `~/.ssh/config` with the appropriate identity file. The alias resolves to `root@147.93.185.240`.

### Web (Apache 2.4.58)

- **DocumentRoot:** `/var/www/congresounisud.com/`
- **Vhost:** `/etc/apache2/sites-available/000-default-le-ssl.conf` (`www.congresounisud.com` + `congresounisud.com` redirect)
- **TLS:** Let's Encrypt (`/etc/letsencrypt/live/www.congresounisud.com/`)
- **Modules enabled:** `rewrite`, `headers`, `deflate`, `ssl` (required by `.htaccess`)
- **`AllowOverride All`** is set on the `<Directory>` block — so `web/.htaccess` is loaded and applied.
- SPA rewrite rules (fallback to `index.html`) live **in the vhost**, not in `.htaccess`. The `.htaccess` carries only cache + compression headers.

### Backend (Tomcat 10)

- **Webapps dir:** `/opt/tomcat10/webapps/` — WAR name **must be `congreso.war`** (context path `/congreso`)
- **Connectors:** `8081` (HTTP internal), `8444` (HTTPS NIO — exposed to the browser, used by the Flutter frontend in release mode)
- **Hot deploy:** replacing `/opt/tomcat10/webapps/congreso.war` triggers automatic redeploy. The scripts delete the expanded `/opt/tomcat10/webapps/congreso/` first and upload atomically via `.war.new` → `mv`.
- **Service:** `systemctl is-active tomcat10` (named `tomcat10`, not `tomcat`)
- **Logs:** `/opt/tomcat10/logs/catalina.out`

---

## Web cache control & deploy pipeline

The frontend build uses a **custom service worker + version.json poller** to ship updates without users needing to hard-refresh. All pieces are reproducible from source:

- **`congreso_frond_end/web/.htaccess`** — Apache cache headers: `no-cache` for entry files (`index.html`, `flutter_bootstrap.js`, `version.json`, `manifest.json`), `max-age=31536000, immutable` for WASM / fonts / images / canvaskit. GZIP on JS/WASM/HTML/CSS/JSON.
- **`congreso_frond_end/web/custom-sw.js`** — Replaces the deprecated `flutter_service_worker.js`. Cache-first for immutable assets + app code; network-only for entry files. `CACHE_VERSION` gets replaced with the pubspec build number on each build (`BUILD_NUMBER_PLACEHOLDER` → `52`, etc.). Stale caches are purged in `activate`.
- **`congreso_frond_end/web/index.html`** — In-head update checker polls `version.json?_t=<ts>` every 60s. If `build_number` changes, shows the green "Nueva versión disponible" banner. Clicking it runs `applyUpdate()`: unregisters all SWs, clears every Cache API entry, clears sessionStorage, hard-reload with `?_update=<ts>`. The `BUILD_TIMESTAMP` placeholder in `flutter_bootstrap.js?v=...` and preload URLs is replaced with the build number at build time to bust HTTP cache.

### Build & deploy commands

```bash
# Frontend: build + deploy to contabo_marco:/var/www/congresounisud.com/
# (from congreso_frond_end/)
powershell scripts/build_web.ps1                 # full pipeline
powershell scripts/build_web.ps1 -NoDeploy       # local build only

# Frontend: just post-process an existing build/web/
powershell scripts/post_build_web.ps1            # Windows
bash      scripts/post_build_web.sh              # Linux/macOS/git-bash

# Backend: mvn package + hot deploy WAR to Tomcat
# (from congreso_back_end/)
powershell scripts/deploy_war.ps1                # full pipeline
powershell scripts/deploy_war.ps1 -SkipBuild     # reuse existing target/*.war
bash      scripts/deploy_war.sh                  # bash equivalent
bash      scripts/deploy_war.sh --skip-build
```

### Bumping the version (required for cache invalidation)

The cache-bust mechanism relies on the **build number** in `pubspec.yaml`. Increment it **before** every production build, otherwise the SW's `CACHE_VERSION` stays the same and users won't receive the update automatically:

```yaml
# congreso_frond_end/pubspec.yaml
version: 1.0.0+53   # bump the number after the + sign
```

The backend WAR has no cache-bust concern — a plain hot deploy is enough; clients pick up API changes on the next request.

### Manual smoke test after a web deploy

```bash
# Must return build_number matching pubspec.yaml
curl -sS -H "Cache-Control: no-cache" https://www.congresounisud.com/version.json

# Must serve Cache-Control: no-cache for entry files
curl -sSI https://www.congresounisud.com/index.html | grep -i cache-control

# Must serve Cache-Control: public, max-age=31536000, immutable for hashed assets
curl -sSI https://www.congresounisud.com/main.dart.js | grep -i cache-control
```

---

## Cross-cutting Notes

- **Single git repo** at the root — both subprojects share one history and branch.
- Backend port `8081` must match `.env` `apiDev`/`portaDev` values in the frontend.
- Secrets are committed (DB password, JWT key, SMTP password, Supabase anon key, Sentry DSN) — match this pattern when adding new config; do not introduce an env-var-only pattern that doesn't exist elsewhere.
- `congreso.sql` is the authoritative MySQL schema + seed — update it when adding tables or columns.
- The `README.md` in each subproject documents only the Dashboard Admin feature — not the full system.
- The `build/web/` post-processing step is **not optional** — running `flutter build web` alone leaves the deprecated `flutter_service_worker.js` in place and does not emit `version.json`, which breaks the update checker. Always use `scripts/build_web.ps1` (or at minimum run `post_build_web.*` after `flutter build web`).
