---
bc-version: [all]
domain: security
keywords: [recordref, recordid, table-no, scope, inherentpermissions]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Keep caller-driven RecordRef.Open procedures non-public

## Description

A codeunit can hold permissions or `InherentPermissions` that its callers do not have. If it exposes a public procedure that accepts a table number or RecordId and calls `RecordRef.Open`, another extension can call that procedure to make the privileged codeunit open tables on its behalf. That turns a generic helper into a permission-bypass surface, especially for system tables.

## Best Practice

Procedures that call `RecordRef.Open` with a caller-provided table number must be `local`, `internal`, or `[Scope('OnPrem')]`. If the procedure truly must be public in SaaS, validate the table number against a narrow allowlist before opening the RecordRef.

See sample: `keep-recordref-open-callers-non-public.good.al`.

## Anti Pattern

A public helper such as `ArchiveRecord(RecId: RecordId)` that opens `RecId.TableNo` and then reads, modifies, or deletes through RecordRef. The helper compiles, but it lets untrusted callers choose which table the privileged code opens.

See sample: `keep-recordref-open-callers-non-public.bad.al`.
