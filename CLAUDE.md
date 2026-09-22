# CLAUDE.md

Guidance for Claude Code (and human contributors) working in this repository.
This file is also our running record of AI-assisted engineering practice on
this project — keep it accurate as real decisions get made, rather than
letting it drift into aspirational documentation.

## What this is

A demo of an agent-assisted private credit workflow: raw deal documents come
in, get turned into structured data, and get evaluated against deterministic
credit logic, with an LLM agent orchestrating the process and an MCP server
exposing it to external clients (e.g. the MCP Inspector, or a chat client).

## Architecture

Data flows left to right through the top-level packages:

```
ingest/  →  parsing/  →  extract/  →  engine/
  ↑                                      ↑
  └──────────────── agents/ orchestrates both ───────────────┐
                                                               │
                                    mcp/mcp_server/  ← exposes agents/ + engine/ as MCP tools
```

- **`ingest/`** — pulls raw source documents and data feeds (loan docs,
  financial statements, vendor feeds) into the pipeline. No parsing or
  interpretation happens here.
- **`parsing/`** — converts raw documents (PDF, Word, Excel) into structured
  intermediate text and tables. Format-handling only, no domain logic.
- **`extract/`** — extracts structured, schema-validated fields and facts
  (covenant terms, financial line items, dates) from parsed documents. This is
  the main LLM-assisted "reading" layer; every output is validated against a
  schema before it leaves this package.
- **`engine/`** — deterministic credit calculations and decisioning (ratios,
  covenant compliance, thresholds). Pure code, no LLM calls, no network I/O.
  See [The "LLMs read, code computes" rule](#the-llms-read-code-computes-rule).
- **`agents/`** — LLM-driven orchestration: prompts and tool-calling agents
  that read documents and reason about next steps, calling into `extract/`
  and `engine/` rather than recomputing anything themselves.
- **`mcp/mcp_server/`** — the project's MCP server, exposing pipeline
  capabilities as MCP tools/resources. The package is named `mcp_server`, not
  `mcp` (see [Conventions](#conventions)), to avoid colliding with the
  upstream `mcp` PyPI package (the official Model Context Protocol SDK).
- **`vendor_mock/`** — local mocks of external vendor APIs (market data,
  credit bureaus, document providers), used in dev and tests so nothing here
  depends on live vendor credentials.
- **`evals/`** — evaluation harnesses and golden datasets for measuring
  extraction and agent accuracy over time.
- **`infra/`** — Azure infrastructure as code (Bicep).
- **`powerautomate/`** — exported Power Automate flow definitions connecting
  this project to Microsoft 365 / Dynamics touchpoints.
- **`docs/adr/`** — architecture decision records (see below).

## The "LLMs read, code computes" rule

LLMs are good at reading unstructured text and bad at arithmetic and
consistent decisioning. This project draws the line accordingly:

- LLMs (in `extract/` and `agents/`) may **read** documents, propose
  structured field values, and decide what to do next.
- LLMs never produce a financial figure, ratio, or pass/fail covenant
  decision directly. That computation always happens in `engine/`, which
  takes validated structured input and returns deterministic, reproducible
  output.
- If you find yourself asking an LLM to "calculate" or "check" a number,
  that logic belongs in `engine/` instead, with `extract/` or `agents/`
  supplying the inputs.

This keeps every number in the system traceable to code you can read, test,
and re-run — not to a prompt that might answer differently next time.

## Conventions

- **Python 3.12**, managed with `uv`. Dev tooling (`ruff`, `mypy`, `pytest`,
  `pre-commit`) lives in the `dev` dependency group in `pyproject.toml`; run
  `uv sync --all-groups` after cloning.
- **Package layout**: each top-level Python package (`ingest`, `parsing`,
  `extract`, `engine`, `agents`, `mcp/mcp_server`, `vendor_mock`, `evals`)
  owns a colocated `tests/` directory. `infra/`, `powerautomate/`, and
  `docs/` are not Python packages.
- **Linting & formatting**: `ruff` (lint + format), configured in
  `pyproject.toml`, enforced by pre-commit and CI. Don't hand-format code
  that `ruff format` would rewrite.
- **Typing**: `mypy --strict`. New public functions need real type
  annotations, not `Any` used as an escape hatch.
- **Testing**: `pytest`. New behavior needs a test before it merges;
  `pytest` runs on the pre-push git hook and on every PR in CI.
- **ADRs**: any decision with lasting architectural consequence (new data
  store, changed trust boundary, a rule like the one above) gets recorded in
  `docs/adr/` using `template.md`, not just left in a PR description or chat
  log.
- **Vendors**: never call a live vendor API from tests or from an agent's
  dev loop — use `vendor_mock/`.
- **Evals**: a change to prompts, extraction logic, or agent tool
  definitions should be checked against `evals/` before merging, the same
  way a code change is checked against `pytest`.

## Working with Claude Code in this repo

- Keep diffs small and reviewable; run `uv run ruff check .`,
  `uv run mypy .`, and `uv run pytest` before proposing a PR — the same
  checks CI runs.
- When a change introduces a real architectural decision, write the ADR as
  part of the change, not as a follow-up.
- Prefer extending `engine/` over asking an agent to reason its way to a
  number — see the rule above.
