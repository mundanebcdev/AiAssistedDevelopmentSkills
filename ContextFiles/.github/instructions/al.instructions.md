---
description: "Business Central AL rules for the security demo app."
applyTo: "bc/**/*.al"
---

# AL demo app instructions

Use these rules when reading, reviewing, or editing AL files in `bc/`.

## Demo context

- The `bc/` app is intentionally insecure. Security issues are present so the `al-security-review` skill has realistic findings to report.
- When the task is a review, identify and explain issues. Do not fix the intentional issues unless remediation is explicitly requested.

## AL conventions

- Target Business Central application 27.0, runtime 16.0, and object IDs 50100-50149.
- Follow extension-only AL development. Do not modify base application objects.
- Name files with the canonical `<Object Name>.<Object Type>.al` pattern when creating new AL objects.
- Use `Label` variables for user-facing `Error`, `Message`, `Confirm`, `StrMenu`, captions, and action labels.
- Follow CodeCop AA0074 suffixes: `Err`, `Msg`, `Qst`, `Lbl`, `Tok`, and `Txt`.
- Add `Comment` metadata for each placeholder in a label. Use `Locked = true` only for technical tokens that should not be translated.

## Security review expectations

- Treat `Text` credentials, hardcoded secrets, plaintext isolated storage, unvalidated `HttpClient` URLs, public caller-driven `RecordRef.Open`, broad permission sets, missing data classification, and unsafe event publisher parameters as high-signal review targets.
- Prefer `SecretText` end to end for credentials and use SecretText-capable HTTP APIs where available.
- Validate user-configurable URLs before outbound HTTP calls.
- Keep findings grounded in the local skill references under `.github/skills/al-security-review/references/`.