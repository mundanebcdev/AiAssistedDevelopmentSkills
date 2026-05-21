---
bc-version: [all]
domain: security
keywords: [event, publisher, extensibility, var-parameter]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Do not expose sensitive data in event publishers

> Contributions welcome — open a PR to refine or extend this article.

## Description

Events in AL are extensibility contracts. Every subscriber — third-party, internal, or installed after the fact — receives the full set of event parameters. Parameters that carry secrets, pre-authorization state, or variables the publisher relies on for access control effectively become public, and var-parameters can be mutated by a subscriber to alter publisher behaviour.

## Best Practice

Design event signatures to carry only the data a subscriber legitimately needs. Do not pass SecretText, credential material, or flags the publisher depends on for access control. Guard variables such as `HasAccess`, `SkipValidation`, or `CanExport` must not be `var` parameters on an OnBefore event; notify subscribers after the internal check with value parameters they cannot mutate.

See sample: `do-not-expose-sensitive-data-in-event-publishers.good.al`.

## Anti Pattern

An OnBeforeElevateAccess publisher that exposes `var CanAccess: Boolean` or `var SkipValidation: Boolean` — any subscriber installed on the tenant can flip it to true and bypass the check. Or a publisher that passes a SecretText parameter it obtained internally, handing it to every subscriber.

See sample: `do-not-expose-sensitive-data-in-event-publishers.bad.al`.

