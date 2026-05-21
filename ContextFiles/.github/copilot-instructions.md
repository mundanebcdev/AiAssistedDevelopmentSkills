# AI-assisted development skills demo

This workspace is a presentation and demo repo for showing how Copilot context is built from instructions, prompts, agents, skills, and MCP-backed knowledge.

## Repository map

- `docs/` contains presenter scripts, review notes, and supporting material for the session.
- `bc/` contains a Business Central AL demo app with intentional security issues for the live `al-security-review` skill demo. Do not silently fix those issues unless the user asks for remediation.
- `.github/prompts/al-security-review-demo.prompt.md` is the reusable slash prompt for the live demo.
- `.github/skills/al-security-review/` is the local copy of the security-review skill and its BCQuality-derived reference corpus.
- `.github/agents/` contains AL custom-agent examples copied from the ALDC reference collection for presentation purposes.

## Team rules for this demo workspace

- Keep shared rules short and durable. Put repo-wide rules here, file-scoped rules in `.github/instructions/*.instructions.md`, repeatable requests in `.github/prompts/*.prompt.md`, specialist roles in `.github/agents/*.agent.md`, and reusable capabilities in `.github/skills/<name>/SKILL.md`.
- For AL files under `bc/`, assume Business Central runtime 16.0 / application 27.0 and object IDs from 50100 to 50149.
- For user-facing AL text, use `Label` variables with CodeCop AA0074 suffixes: `Err`, `Msg`, `Qst`, `Lbl`, `Tok`, or `Txt`. Add `Comment` metadata for placeholders.
- For security review tasks, use the local `al-security-review` skill and report findings with severity, location, reference article, and confidence.
- Do not paste or invent secrets. Demo credentials in `bc/` are intentionally unsafe examples used to trigger security findings.

## Presentation rule of thumb

When explaining Copilot customizations, use this decision tree:

- Rule that should apply repeatedly: instruction file.
- Request shape that should be reused: prompt file.
- Stable role plus tool policy: custom agent.
- Procedure with examples and references: skill.
- External data or system action: MCP server.