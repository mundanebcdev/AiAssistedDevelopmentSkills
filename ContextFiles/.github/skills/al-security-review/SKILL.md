---
name: al-security-review
description: "Security review for Business Central AL code. Reviews AL source — diffs, files, or pasted snippets — against the BC security knowledge corpus (secrets handling, SecretText, IsolatedStorage, Azure Key Vault, OAuth2, permission sets, indirect/inherent permissions, RecordRef.Open, URL validation before HttpClient, data classification, event-publisher hygiene, ValidateTableRelation). Emits findings with severity, file:line location, and a citation back to the knowledge article that applies. WHEN: review AL code for security, BC security review, Business Central security audit, check AL secrets, audit AL permission sets, AL OAuth2 review, BC AppSource security check, review BC extension before merge, AL code review security, security findings on AL diff."
license: MIT
metadata:
  source: github.com/microsoft/BCQuality
  version: "0.1.0"
---

# AL Security Review (Business Central)

This skill reviews **Business Central AL source** for security concerns by consulting a curated set of knowledge articles drawn from [BCQuality](https://github.com/microsoft/BCQuality). Each article documents one Best Practice and Anti Pattern with paired `.good.al` / `.bad.al` examples. The skill matches code in front of the user against those patterns and emits findings.

It is a leaf reviewer — it does not modify code. Apply fixes manually after reviewing the findings.

## When to use this skill

- The user asks for a **security review** of an AL file, codeunit, permission set, or PR diff
- The user pastes AL code and asks "is this secure?", "any secrets issue?", "permission review", etc.
- The user is about to publish to AppSource and wants a pre-flight security check
- An AL diff touches: `HttpClient`, `Uri`, `SecretText`, `IsolatedStorage`, `OAuth2`, `Password`, `Token`, `RecordRef.Open`, `Commit`, permission sets, integration events, or data classification

## When NOT to use this skill

- Non-AL code (C#, JavaScript, PowerShell). This skill is AL-only.
- Performance, style, UX, or upgrade concerns. Those are separate review domains.
- The user wants to *learn* a concept rather than review code — point them at the relevant article in `references/` directly.

## Inputs the skill accepts

- A **PR diff** (best signal — changed lines + filenames).
- A **file path** to one or more `.al` files in the workspace.
- A **pasted snippet** of AL code in the chat.

If none of these are present, ask the user to point you at the code under review before proceeding.

## How to review

Work in four passes. The order matters — early passes cheaply prune the corpus before expensive matching.

### 1. Source — the knowledge corpus

All articles under `references/microsoft/` and `references/community/`. Each `*.md` is one concern. Sibling `*.good.al` / `*.bad.al` files are illustrative samples for that concern, not standalone code.

Frontmatter fields you will use:

- `keywords` — free-text tags (`secrets`, `permission`, `oauth2`, `httpclient`, `recordref`, …).
- `bc-version` — `[all]` or a range like `[26..28]`.
- `technologies` — always `[al]` for this corpus.

### 2. Relevance — discard articles that don't apply

Keep an article when:

- `technologies` includes `al` (every article in this corpus does).
- `bc-version` matches the target environment. If the workspace `app.json` declares an `application` or `platform` version, match against it. If unknown, keep the article but cap finding `confidence` at `medium` and say so in the message.

`countries` and `application-area` are unconstrained in this corpus (`[w1]`, `[all]`) — no filtering needed.

### 3. Worklist — narrow to articles that match the code

Tokenize the code under review and compute overlap against each article's `keywords` and title. High-signal tokens to look for in the AL source:

`IsolatedStorage`, `SetEncrypted`, `OAuth2`, `SecretText`, `Unwrap`, `NonDebuggable`, `Password`, `Token`, `HttpClient`, `Uri`, `AreURIsHaveSameHost`, `IsValidURIPattern`, `RecordRef`, `RecordId`, `Open`, `IntegrationEvent`, `BusinessEvent`, `SkipValidation`, `HasAccess`, `Permission`, `UserSecurityId`, `Commit`, `CommitBehavior`, `DataClassification`, `TableRelation`, `ValidateTableRelation`, `IsTemporary`, `permissionset`, `IncludedPermissionSets`, `InherentPermissions`.

Also weight by object kind: permission set changes pull in the permission-set articles; codeunits that call `HttpClient` pull in URL-validation and SecretText articles; etc.

When the same concern appears in both `microsoft/` and `community/` and they conflict, **Microsoft wins** — drop the community one and record it as suppressed in your finding output.

### 4. Action — evaluate and emit findings

For each article in the worklist, compare the code against its `## Anti Pattern` and `## Best Practice` sections. Use the paired `.bad.al` / `.good.al` files as illustrative ground truth for what the pattern looks like.

Emit one finding per match. Findings use this markdown shape, one per bullet:

```
- **[severity]** `path/to/file.al:line` — short message explaining the issue.
  Reference: `references/<layer>/<article>.md`.
  Confidence: high|medium|low.
```

Severity rules:

- `blocker` — the article calls out a platform-level guarantee (documented secret-handling rule, permission-model invariant, data-protection requirement) and the code clearly violates it.
- `major` — a clean match for an Anti Pattern that the article does not escalate to platform-level.
- `minor` — code contradicts a Best Practice without being a full Anti Pattern.
- `info` — the article is clearly applicable but no concrete violation was detected; surface the citation so the author can self-check.

Confidence rules:

- `high` — unambiguous pattern match (identifier, syntax, object type).
- `medium` — heuristic match, or `bc-version` was unknown.
- `low` — advisory only, derived from applicability rather than a concrete match.

After the findings list, add a short **Summary** with counts per severity and a list of articles consulted (so the user can see what was checked even when nothing fired).

If a community article was suppressed because a Microsoft article on the same concern was preferred, add a **Suppressed** section listing it.

## Output format (chat-friendly)

```markdown
## Security review — <file or PR>

### Findings
- **blocker** `src/Integration/ApiClient.Codeunit.al:85` — Bearer token declared as Text; the referenced guidance requires SecretText end-to-end.
  Reference: `references/microsoft/use-secrettext-for-credentials.md`. Confidence: high.
- **minor** `src/Integration/ApiClient.Codeunit.al:201` — API key assigned from a string literal.
  Reference: `references/microsoft/never-hardcode-secrets-in-al.md`. Confidence: medium.

### Summary
- 1 blocker, 0 major, 1 minor, 0 info
- 6 articles consulted; 2 fired.

### Suppressed
- `references/community/prefer-oauth2-over-api-keys-for-external-http-calls.md` — superseded by Microsoft article on the same concern.
```

When no findings fire and the worklist was non-empty, say so explicitly: *"No security issues detected against N relevant articles."* Do not silently emit an empty report.

When no article was relevant at all, say *"No applicable security knowledge for this change."* — this is meaningful information, not a no-op.

## Notes on the corpus

The articles in `references/microsoft/` come from the Microsoft-endorsed layer of BCQuality. The articles in `references/community/` come from the community layer. Layer precedence on conflict: **custom > community > microsoft** for *layer overrides* (BCQuality's general rule), but in this skill **only microsoft and community are present**, and **microsoft wins on conflict** because the community files in this corpus do not declare themselves as overrides. If you later add a `references/custom/` layer with override files, custom wins.

To update the corpus, re-copy from `microsoft/knowledge/security/` and `community/knowledge/security/` in the BCQuality repo. No code changes are needed in this skill when articles are added or revised.
