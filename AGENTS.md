# Repository Guidelines

## Project Structure & Module Organization

This repository contains two applications. `congreso_back_end/` is a Java 17 Spring Boot service packaged as a WAR. Production code lives under `src/main/java/py/com/flextech/`; SQL mappers, application profiles, mail templates, and reports are under `src/main/resources/`. `congreso_frond_end/` is the Flutter application: shared infrastructure belongs in `lib/core/`, business features in `lib/modules/`, static files in `assets/`, and web bootstrap files in `web/`. `congreso.sql` is the reference MySQL schema and seed script. Keep backend and frontend changes aligned when an API contract changes.

## Build, Test, and Development Commands

Run commands from the relevant subproject.

```powershell
# Backend
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=dev
.\mvnw.cmd test
.\mvnw.cmd clean package

# Frontend
fvm flutter pub get
fvm flutter run -d chrome
fvm flutter analyze
fvm flutter test
fvm dart run build_runner build --delete-conflicting-outputs
powershell scripts/build_web.ps1 -NoDeploy
```

The final frontend command builds and post-processes the web bundle without deploying it. Regenerate code after changing MobX stores or JSON-serializable models.

## Coding Style & Naming Conventions

Use four-space indentation in Java and standard `dart format` output (two spaces) in Dart. Java types use `PascalCase`; methods and fields use `camelCase`. Dart files use `snake_case.dart`, widgets/classes use `PascalCase`, and generated files retain the `.g.dart` suffix. Follow the existing frontend flow `Page -> Ctrl/Store -> Service -> Repository` and the backend `Controller -> Service -> Repository/Mapper` layering. Keep MyBatis XML beside its domain under `resources/mappers/`.

## Testing Guidelines

The backend includes JUnit 5 through `spring-boot-starter-test`; name tests `*Test.java` and mirror production packages under `src/test/java`. Flutter uses `flutter_test`; place tests under `test/` and name them `*_test.dart`. There is currently no committed active test suite or coverage threshold. Add focused regression tests for new behavior and run analysis plus the affected suite before opening a PR.

## Commit & Pull Request Guidelines

History uses short Spanish descriptions but has no enforced prefix. Prefer specific, scoped subjects such as `taller: valida cupos de inscripción`; avoid placeholders like `commit pendiente`. PRs should explain the user-visible change, affected application(s), schema or configuration impact, and exact validation commands. Link the issue when applicable and attach screenshots for Flutter UI changes. Never commit credentials or production `.env` values, and do not run deployment scripts as part of routine verification.
