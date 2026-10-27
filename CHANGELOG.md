# Changelog

## 2026-10-27 — Audit follow-up

- Screening inference now fails closed with HTTP 503 rather than fabricating a random risk result.
- Added production environment configuration for JWT secrets, CORS origins, and database URLs, including PostgreSQL psycopg support.
- Tightened authentication and role checks for screening, user, and intervention operations; public registration is parent-only.
- Corrected Flutter OAuth2 login form encoding and handling of list-valued API responses.
- Recommendations now resolve demographics from the selected student record; removed hard-coded clinical-result copy and example recommendations.
- Added `httpx2` for Starlette TestClient compatibility and added API regression cases.
- Updated README and progress claims and added audit, roadmap, task, and test-status documentation.
- Verification: backend syntax compilation passed; 4 predictor tests passed. API suite and Flutter analysis remain unverified in this environment.
