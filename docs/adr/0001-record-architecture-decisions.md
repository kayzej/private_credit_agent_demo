# 0001. Record architecture decisions

Date: 2026-09-21

## Status

Accepted

## Context

The project spans document ingestion, extraction, deterministic credit
calculations, and LLM-driven agents. Decisions in any one of these areas
(e.g. why extraction output is schema-validated, why a calculation lives in
`engine/` instead of a prompt) need to be discoverable by future contributors
and reviewers without re-deriving them from code or chat history.

## Decision

We will use Architecture Decision Records, as described by Michael Nygard, to
record any decision with lasting architectural consequence. Records live in
`docs/adr/`, are numbered sequentially, and use `template.md` as their
starting point. A decision is superseded by writing a new ADR that links back
to the one it replaces, not by editing the original.

## Consequences

Architecturally significant choices have a durable, reviewable paper trail.
This adds a small amount of process overhead (writing the ADR) in exchange for
not having to reconstruct "why" from commit messages or memory later.
