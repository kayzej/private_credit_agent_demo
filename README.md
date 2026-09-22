# private-credit-agent-demo

Demo of an agent-assisted private credit workflow: document ingestion,
extraction, deterministic credit calculations, and an LLM agent orchestrating
the pipeline via MCP.

See [`CLAUDE.md`](./CLAUDE.md) for architecture and conventions, and
[`docs/adr/`](./docs/adr/) for the decision log.

## Getting started

Open in the provided dev container (Python 3.12, `uv`, Azure CLI, Bicep,
Node 20), or locally:

```bash
uv sync --all-groups
uv run pre-commit install --install-hooks
uv run pre-commit install --hook-type pre-push

uv run ruff check .
uv run mypy .
uv run pytest
```
