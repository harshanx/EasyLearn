# Project Progress Tracker (Reality-Checked)
## AI-Based Learning Difficulty Screening & Explainable Intervention Support Platform (EasyLearn)

> Last updated: 2026-10-27. Status below reflects source inspection and checks completed for the audit follow-up.

## Overall status

| Area | Status | Verified state |
|---|---|---|
| Flutter demo UI | Implemented | Screens and role dashboards exist; runtime/build checks are pending. |
| FastAPI and database | Implemented | SQLite default, SQLAlchemy models and CRUD routes exist. |
| API integration | Partially implemented | Client and services exist; login form encoding and JSON list handling were corrected. Full client/server flow is not verified. |
| Authentication and access | Partially implemented | JWT login and role checks exist. Record ownership, account recovery, and rate limiting remain. |
| Recommendations | Implemented; verification pending | Feature mapping and age/grade filtering exist; client now requests demographics from the selected student record. |
| ML and explanations | Artifacts present; validation pending | Bundled XGBoost model and predictor tests work. Dataset provenance and independent model validation are not established. |
| QA | Incomplete | Four predictor tests passed; API suite and Flutter analysis did not complete. |
| Production readiness | In progress | Secret, CORS, and database URL configuration added; deployment and operational controls remain. |

## Phase 1 — Flutter demo UI

**Status: implemented.** Role dashboards, settings, localization, and demo flows exist in the Flutter source. Flutter analysis and widget tests remain to be run in a functioning Flutter environment.

## Phase 2 — FastAPI and database

**Status: implemented; runtime verification incomplete.** FastAPI routers, SQLAlchemy models, Pydantic schemas, database initialization, and intervention seeding are present. SQLite is the default. `DATABASE_URL` supports PostgreSQL URLs through psycopg. No migration framework or live PostgreSQL verification is present.

## Phase 3 — Frontend/API integration

**Status: implemented; end-to-end verification pending.** Flutter services cover users, students, screenings, and interventions. Login now sends OAuth2 form fields, and list-valued JSON responses are supported. The default API URL remains `http://10.0.2.2:8000`; platform-specific URL selection is not implemented. A prior workspace note reported Windows/Web socket timeouts; that report was not reproduced here because local socket access was unavailable.

## Phase 4 — Authentication and access control

**Status: partial.** JWT login, password hashing, protected student/screening routes, admin-only account/intervention writes, and parent-only public registration are implemented. Production requires `SECRET_KEY` and explicit `CORS_ORIGINS` with `APP_ENV=production`.

Remaining: record-level ownership and teacher/class/school relationships, administrator bootstrap/recovery, token refresh, login rate limiting, and secure mobile token storage. Authenticated users can still reach broader student/screening collections than a production privacy policy should allow.

## Phase 5 — Interventions and recommendations

**Status: implemented; end-to-end check pending.** The backend maps SHAP features to intervention categories and filters by age and grade. The Flutter result flow now supplies a student ID so the backend reads saved demographics rather than using hard-coded values. The recommendation endpoint remains a separate request from prediction.

## Phase 6 — ML model and explainability

**Status: artifacts present; validation pending.** Model, scaler, feature columns, and metadata joblib files are bundled. Predictor tests for model load, prediction, class probabilities, and top features passed (4 tests).

The training script references a WALS CSV at a machine-specific path outside the repository. It derives difficulty features and target labels from `neurodivergence_type`, so reported accuracy is not independent evidence of screening validity. The mapped school age is 15; the app may screen younger children. Provenance, representative validation, calibration, and clinical appropriateness remain unresolved. Prediction now returns HTTP 503 without storing a fabricated result when inference fails.

## Phase 7 — Flutter screening and results UI

**Status: implemented; analysis/runtime verification pending.** Questionnaire, result, probability, SHAP, and recommendation UI are implemented in Dart. Result text now describes the output as non-diagnostic and does not show static example recommendations when loading fails. Dashboard student data still includes demo/mock content.

## Phase 8 — Testing and QA

**Status: incomplete.** Python syntax compilation passed and the 4 predictor tests passed. The API TestClient suite stalled at `test_health` with Starlette falling back to deprecated `httpx`; `httpx2` was added to backend requirements but is not installed in the current environment. Flutter analysis produced no result before interruption. The full API/client flow and live HTTP behavior remain unverified.

See `TESTING.md` for check results and limitations.

## Phase 9 — Production hardening

**Status: in progress.** Environment-driven `SECRET_KEY`, explicit production CORS origins, `DATABASE_URL`, and PostgreSQL driver support are implemented. HTTPS, deployment, production database provisioning, migrations/backups, login rate limiting, logging/monitoring, mobile secure token storage, and release builds remain.

## Next priorities

1. Install backend dependencies, including `httpx2`, and complete API tests.
2. Run Flutter analysis and tests, then verify login → student → screening → result → recommendation.
3. Confirm record ownership and teacher/school access rules before enabling production access.
4. Reconcile `SDD_EasyLearn.md` and `SRS_EasyLearn.md` with confirmed project intent.
5. Validate model data and claims on independent, representative data with qualified reviewers.
