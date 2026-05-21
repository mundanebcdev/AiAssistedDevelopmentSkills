---
bc-version: [all]
domain: security
keywords: [url, uri, httpclient, ssrf, validation, endpoint]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Validate user-configurable URLs before HTTP calls

## Description

URLs stored in setup tables or accepted from user input are user-configurable endpoints. Passing them directly to `HttpClient` lets a malicious or compromised setup value redirect the extension to internal services, metadata endpoints, or attacker-controlled hosts. Business Central's System Application `Uri` codeunit provides host and pattern validation helpers for this exact boundary.

## Best Practice

Before `HttpClient.Get`, `Post`, `Put`, or similar calls use a URL from a table field, validate it with `Uri.AreURIsHaveSameHost()` when the host must be fixed, or `Uri.IsValidURIPattern()` when a known URL pattern is allowed. Validate before writing the request body so sensitive payloads are never sent to an unexpected host.

See sample: `validate-user-configurable-urls-before-http-calls.good.al`.

## Anti Pattern

Reading `Setup."Service URL"` or `WebhookSetup."Callback URL"` and passing it directly to HttpClient. The code looks configurable, but it creates an SSRF path and can exfiltrate data to whichever host the setup row names.

See sample: `validate-user-configurable-urls-before-http-calls.bad.al`.
