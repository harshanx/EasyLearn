# Task Tracker

Updated 2026-10-27.

## Current task — Audit follow-up fixes

**Status: Partially complete; runtime verification remains.**

### Completed

- Replaced mock risk generation on model failure with HTTP 503 and no persisted result.
- Added environment configuration for production JWT secret, CORS origins, and database URL; added PostgreSQL driver support.
- Protected screening routes, limited user management, prevented public admin registration, and restricted intervention writes to admins.
- Fixed OAuth2 login form encoding and JSON list response handling in the Flutter API client.
- Changed recommendations to use the selected student's stored age and grade rather than hard-coded demographics.
- Removed invented clinical narrative and static fallback intervention recommendations from the result UI.
- Corrected stale implementation and verification claims in `README.md` and `PROGRESS.md`.
- Added verified audit, roadmap, task, changelog, and test-status records.

### Remaining

- Complete the backend API suite after installing `httpx2` from the updated requirements.
- Complete Flutter analysis and tests.
- Define and implement record-level ownership rules and teacher/school access relationships.
- Validate model provenance and performance on suitable independent data.
- Add login rate limiting, administrator bootstrap/recovery, operational health checks, and secure token storage.
- Review SDD/SRS conflicts and confirm which are intended requirements.

### Blockers / limits

- Current environment lacks `httpx2`; the legacy Starlette TestClient run stalled.
- Flutter analysis did not complete in the available session.
- Local socket access prevented a live server request.
