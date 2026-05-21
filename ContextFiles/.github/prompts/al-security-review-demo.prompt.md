---
description: "Review the BC demo app with the local al-security-review skill."
name: "AL Security Review Demo"
argument-hint: "Optional target path, defaults to bc/*.al"
agent: "agent"
---

Use the workspace-local `al-security-review` skill at `.github/skills/al-security-review` to review the AL app in `bc` or the target I provide. This workspace copy is duplicated from `C:\Users\mak\.agents\skills\al-security-review` so it can be shown during the presentation.

Focus on Business Central AL security issues only. Emit findings in the skill format: severity, file:line, short explanation, reference article, and confidence. End with a summary count and the consulted articles. List code links to issues in a message so it is easy to click through. Write the output into md file.