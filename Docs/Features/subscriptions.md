# CobraSthenics — Subscriptions

Subscriptions cover entitlement state, premium feature access, paywall messaging, and account-level plan details.

## Product Rules

- Keep subscription copy direct and concrete.
- Do not use hype or exaggerated claims.
- Use brand blue for primary subscription actions.
- Use the full COBRA / STHENICS wordmark only on splash and paywall surfaces.

## Entitlement States

Expected states:

- Unknown/loading
- Free
- Trial
- Active subscriber
- Expired
- Billing issue

## Feature Gating

Feature gates should explain what is unavailable and what action is available. Avoid blocking unrelated navigation.

## Backend Needs

Subscription code should use domain use cases backed by StoreKit 2 or RevenueCat adapters for:

- Current entitlement
- Renewal or expiration date
- Product identifiers
- Paywall eligibility
- Restore-purchase result

Dates and numeric values must use DM Mono in UI.
