# Verified Project Audit

**Audit date:** 2026-10-27
**Status:** Source-inspected; runtime verification is partial.

## Verified architecture

- Flutter client under `flutter_app/` calls a FastAPI service under `backend/`.
- FastAPI registers auth, user, student, screening, and intervention routers in `backend/app/main.py`.
- SQLAlchemy uses SQLite by default. `DATABASE_URL` can select another SQLAlchemy-supported backend; PostgreSQL URLs use psycopg.
- Screening prediction loads the bundled joblib model, scaler, and feature list through `backend/ml/predictor.py`; SHAP contributions and class probabilities are returned with screening responses.
- Model or explanation failures now return HTTP 503 and do not persist a fabricated risk result.
- The client uses OAuth2 form encoding for login, bearer tokens for protected calls, and JSON for other API requests.

## Access controls and current limits

- JWT secret configuration is environment based. Production requires `SECRET_KEY`; production CORS requires an explicit `CORS_ORIGINS` allowlist.
- Student and screening routes require authentication. User listing and deletion, and intervention creation, update, and deletion, require an admin role. Users can read or update their own profile; admins can access other profiles.
- Public registration is limited to parent accounts.
- Student and screening record ownership is not fully enforced. The schema has a parent link but no class, school, teacher assignment, or student-account relationship. Authenticated roles can still access broader student/screening collections than a production privacy model should permit. Resolve those relationships before production use.
- No supported admin bootstrap or recovery workflow is implemented. Initial admin setup currently requires a controlled database operation.
- The admin dashboard shows static service-health indicators; it does not query backend health or model status.
- Access tokens are stored using Flutter `SharedPreferences`; secure platform storage is not implemented.

## Model evidence and limitations

- Bundled model, scaler, feature columns, and metadata artifacts exist.
- `backend/ml/train_model.py` points to a machine-specific dataset path outside this repository. The dataset and its provenance are not included.
- Training labels are mapped from `neurodivergence_type`, while difficulty features are also engineered from that category. Historical 100% accuracy claims are not independently reproduced and do not establish clinical validity.
- Training age values map the school cohort to age 15, while the questionnaire flow is used for children and may contain younger students. This creates an unverified distribution mismatch.
- The model tests pass against the bundled artifacts, but these tests verify software behavior, not screening quality or clinical appropriateness.

## Documentation discrepancies corrected

- Root `README.md` previously described prediction as mock-only, login as a placeholder, and training as synthetic Random Forest data. It now describes current XGBoost artifacts, failure behavior, configuration, and known model evidence limits.
- `PROGRESS.md` previously marked the complete backend suite and Flutter analysis as passing, described an offline fallback, and marked several security changes as pending/completed inconsistently. It now marks unverified checks and remaining work explicitly.
- `SDD_EasyLearn.md` and `SRS_EasyLearn.md` are project design documents whose architecture claims do not match the current implementation in all details. They were left unchanged because whether those claims are intended requirements or historical designs is unresolved. In particular, the SDD describes Firebase flows while the running source uses FastAPI/SQLAlchemy/JWT. Review these documents before treating them as implementation requirements.

## Verification status

- Python syntax compilation for changed backend modules: passed.
- ML predictor tests: 4 passed.
- API tests: did not complete in this environment. Starlette emitted a deprecation warning about falling back to `httpx`; `httpx2` was added to backend requirements, but it is not installed in the current environment. The existing TestClient run stalled at the health check.
- Flutter analysis: inconclusive; the command produced no output and remained running until interrupted.
- Live HTTP runtime check: blocked by local socket access restrictions in the execution environment.

## Open risks

1. Define and enforce student/screening ownership and teacher/school access rules.
2. Review dataset provenance, label construction, age coverage, calibration, and independent validation with qualified domain reviewers.
3. Implement a controlled administrator bootstrap/recovery flow and login rate limiting.
4. Use secure token storage and operational health/monitoring checks.
5. Reconcile the SDD/SRS with confirmed project intent.
