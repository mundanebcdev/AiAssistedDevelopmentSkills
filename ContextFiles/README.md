# Copilot Context Files — Business Central AL Examples

Real-world examples of GitHub Copilot customization files used in a Business Central AL development workflow. These demonstrate how to combine **instructions**, **prompts**, **agents**, and **skills** to build domain-specific AI assistance.

## What's inside

```
.github/
├── copilot-instructions.md          # Repo-wide rules loaded into every chat
├── instructions/
│   └── al.instructions.md           # AL coding conventions for bc/ files
├── prompts/
│   └── al-security-review-demo.prompt.md
├── agents/
│   └── al-developer.agent.md        # Tactical implementation specialist
└── skills/
    └── al-security-review/          # Security review skill + knowledge corpus
        ├── SKILL.md
        └── references/
            ├── microsoft/           # Good/bad AL samples from MS guidelines
            └── community/           # Good/bad AL samples from community patterns

bc/                                  # Demo AL app (intentionally insecure)
├── app.json
├── Security Demo Customer List.PageExt.al
├── Security Demo Export Buffer.Table.al
├── Security Demo Full Access.PermissionSet.al
├── Security Demo Lookup.Table.al
├── Security Demo Mgt.Codeunit.al
├── Security Demo More Risks.Codeunit.al
├── Security Demo Roles.PermissionSet.al
├── Security Demo Setup.Page.al
└── Security Demo Setup.Table.al
```

## How these files work together

| File type | Purpose | Loaded when |
|-----------|---------|-------------|
| `copilot-instructions.md` | Shared team rules | Every Copilot interaction |
| `.instructions.md` | Scoped conventions | Editing files matching `applyTo` pattern |
| `.prompt.md` | Reusable task template | User invokes with `/` command |
| `.agent.md` | Specialist role + tools | User switches to custom agent mode |
| `SKILL.md` | Procedure + reference data | Agent or prompt references the skill |

## Decision tree

Use this when choosing which file type to create:

- **Rule that should apply repeatedly** → instruction file
- **Request shape that should be reused** → prompt file
- **Stable role plus tool policy** → custom agent
- **Procedure with examples and references** → skill
- **External data or system action** → MCP server

## The demo AL app

The `bc/` folder contains a Business Central extension with **intentional security issues** — hardcoded secrets, overly broad permissions, missing data classification, and more. It exists so the `al-security-review` skill has realistic findings to report during a live demo.

> **Do not use this code in production.** The security anti-patterns are deliberate teaching examples.

## Security review skill

The skill under `.github/skills/al-security-review/` reviews AL source against a knowledge corpus covering both Microsoft and community guidelines. Each reference article documents one security concern with good/bad AL examples:

**Microsoft guidelines**
- SecretText for credentials and HTTP calls
- NonDebuggable attribute when parsing secrets
- IsolatedStorage for module and company secrets
- Azure Key Vault for production secrets
- Composing secrets with `SecretStrSubstNo`
- Least privilege in permission sets
- Indirect and inherent permissions for elevated access
- RecordRef.Open caller visibility
- ValidateTableRelation on user input
- Event publishers and sensitive data exposure
- CommitBehavior attribute scoping
- No hardcoded environment-specific GUIDs

**Community guidelines**
- Data classification on every table field
- Composing permission sets with included sets
- Protecting sensitive data in temporary tables
- Guarding bulk operations with `IsTemporary`
- OAuth2 over API keys for external HTTP calls

## Requirements

- VS Code with [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) extension
- The AL Language extension (for BC development context)
