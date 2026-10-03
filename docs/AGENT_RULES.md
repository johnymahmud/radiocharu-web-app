# Agent Rules & Non-Destructive Workflow Guidelines

## Core Philosophy
We are building **Radio Charu** as a resilient, production-grade 24/7 online broadcasting platform. To preserve stability, maintain memory across sessions, and prevent regressions, all AI interactions and developer actions MUST adhere to the following rules.

---

### Rule 1: Memory-First Execution
- **Always inspect `docs/CURRENT_STATE.md`** before planning or writing any code.
- Ensure full alignment with `docs/MASTER_BLUEPRINT.md` architecture and conventions.
- Never make arbitrary assumptions regarding ports, container names, or streaming endpoints.

### Rule 2: Non-Destructive Safety & Secret Protection
- **Never execute destructive Git commands** (e.g., `git reset --hard`, `git clean -fdx`, force pushes) without explicit confirmation.
- **Never commit or expose secrets**: Icecast source/admin passwords, Cloudflare tunnel tokens/credentials, and Firebase service account keys must reside solely in `.env` files or secure secret stores.
- Request explicit user approval prior to modifying network configurations, firewall rules, or production `.env` parameters.

### Rule 3: Phase-by-Phase Isolation & Modularity
- Develop features strictly within their designated phase boundaries.
- Validate each modular layer (e.g., Icecast engine -> Tunnel -> Web player -> Admin interface) independently with reproducible smoke tests before proceeding to downstream features.
- Keep components decoupled:
  - `server/icecast/` handles raw audio streaming and status metadata.
  - `server/tunnel/` bridges network connectivity securely without opening router ports.
  - `web/` focuses on listener playback, telemetry, and visualizer aesthetics.
  - `admin/` provides dedicated RJ control and shoutbox moderation.
  - `shared/` manages cross-boundary schemas and utilities.

### Rule 4: Ledger & State Synchronization
- After completing any sub-feature, bugfix, or architectural change, immediately update:
  1. `docs/CURRENT_STATE.md` (active status, working endpoints, completed items).
  2. `docs/PROJECT_LOG.md` (chronological entries with timestamps and rationale).
  3. `docs/NEXT_STEPS.md` (next actionable tasks and milestones).

---
*Enforced for all human-in-the-loop and autonomous agent sessions in Antigravity IDE.*
