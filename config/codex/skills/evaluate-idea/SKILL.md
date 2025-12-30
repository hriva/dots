---
name: evaluate-idea
description: Use this when receiving a change request between the <idea> or <ideas> tags before proposing any changes - 6 point framewor for considering proposed changes (research, confidence gating, intent decomposition, tree of thought alternatives, other angles and refutations) that ensures careful consideration of the impacts and alternatives before attempting changes.
---

<idea_evaluation_framework>
<preflight>
- Summarize the task in 1‑2 sentences and restate the desired goal.
- Define constraints (performance, security/compliance, interface contracts, timelines).
- Define non-goals.
- Define success criteria (objective, measurable, verifiable).
- Set time/compute budgets for exploration.
</preflight>

<research_and_verification>
- Build a call hierarchy for the change path:
  - Identify entrypoints, primary functions/methods, cross-cutting concerns (logging, caching, auth).
  - Trace read/write side effects, external I/O boundaries, and error handling flows.
- Investigate the codebase to 99% certainty:
  - Read relevant files, tests, and fixtures.
  - Map current behavior vs. desired behavior.
  - Note invariants and pre/post-conditions.
- Read official documentation via MCP:
  - Use context7 resolve-library-id → get-library-docs for all relevant libraries/APIs.
  - Cite exact versions and authoritative pages.
- Produce a sources/citations list with file paths, line ranges, and doc URLs.
</research_and_verification>

<confidence_gate>
- Provide a quantified confidence report (0.00–1.00) with sub-scores:
  - Codebase understanding, API/Docs fidelity, Constraints clarity, Risk surface, Data Structures.
- If confidence < 0.99:
  - Enumerate unknowns blocking confidence.
  - Plan to resolve (targeted file reads, focused tests, minimal repros, doc lookups).
  - Loop back to <research_and_verification> until ≥0.99 or explicitly explain why it’s not achievable under current constraints and propose a bounded experiment.
</confidence_gate>

<intent_decomposition>
- State the underlying intent and problem framing (the “why” behind the idea).
- Extract invariants that must hold after implementation (correctness, security, data contracts).
- Identify compliance/regulatory/privacy requirements and data handling rules.
- Identify operational constraints (deploy process, rollbacks, observability, SLOs).
</intent_decomposition>

<tree_of_thought>
- Generate branches (≥3 plus a “do nothing/minimal change” baseline):
  - Branches should vary by architecture choice, data flow, dependency strategy, and risk.
- For each branch, list key assumptions and the smallest falsifiable test to validate them.
- Score each branch using this rubric (weights sum to 1.0):
  - Simplicity: 0.35
  - Robustness/Reliability: 0.30
  - Compliance/Security: 0.20
  - Maintainability: 0.10
  - Performance: 0.05
- Compute a weighted score and provide a short justification for each dimension.
- Prune branches with low scores, keep top 1–2 for deeper analysis.
</tree_of_thought>

<multi_angle_outlook>
- Architecture-level alternatives (module boundaries, sync vs async, policy vs mechanism, data structures).
- Process/tooling alternatives (linting, CI, codegen, contract tests).
- Non-code alternatives (config changes, feature flags, operational runbook).
- “Bigger picture” check: does the problem suggest a systemic issue (APIs, schemas, ownership)?
</multi_angle_outlook>

<refutation_and_gotchas>
- Refute misguided ideas and incorrect assumptions found during research.
- Call out anti-patterns, hidden coupling, leaky abstractions, and test fragility risks.
- Security/compliance gotchas (PII handling, authZ gaps, injection, supply-chain risks).
- Performance pitfalls (N+1, blocking I/O, contention, unbounded fan-out).
- Migration risks (data backfills, idempotency, versioning).
</refutation_and_gotchas>

<decision_and_exit_criteria>
- Select the simplest, most robust branch that meets success criteria and constraints.
- State explicit EXIT: choose the minimal-change solution that passes the rubric and compliance gates.
- Provide a focused implementation sketch:
  - Exact files/functions to change and the minimal diff strategy.
  - Observability plan (logs, metrics, traces) to validate behavior.
  - Test plan (unit, contract, integration) with high-signal cases and edge conditions.
  - Rollback plan and guardrails (feature flag, canary, version pin).
- Provide a brief risk register and mitigations.
</decision_and_exit_criteria>

<outputs>
- Research summary with citations (code paths, line ranges, docs URLs).
- Call hierarchy map of the affected flow.
- Confidence report with sub-scores and, if needed, loop-back plan.
- Alternatives matrix with rubric scores and justifications.
- Decision rationale and EXIT confirmation (why this is the simplest robust choice).
- Implementation sketch, observability plan, test plan, rollback plan.
</outputs>

<CRITICAL>
Do not make code changes yet. Present only the conclusion, decision rationale, and the exact next steps required to implement safely.
</CRITICAL>

<conclusion>
- Understood intent of the evaluated idea
- Final recommendation and why it wins under the rubric.
- Expected impact on correctness, security/compliance, and maintainability.
- Immediate next actions to implement with estimated effort and verification steps.
</conclusion>
</idea_evaluation_framework>
