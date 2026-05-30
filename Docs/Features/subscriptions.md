# Subscriptions

There is no `Features/Subscription/` folder, no StoreKit code, and no RevenueCat integration in the current codebase. Subscription content lives entirely inside the Settings feature as a single static view.

## Where Subscription UI Lives Today

| Surface | File | Notes |
|---|---|---|
| Subscription screen | `Features/Settings/Presentation/Views/SubscriptionView.swift` | Reached from `ProfileView` via the `SettingsRoute.subscription` row in the App settings group. Static layout — no purchasing or entitlement state. |
| Premium badge in settings list | `Shared/SampleData/SampleData.swift` → `settingGroups[1].items` | `SettingItemModel(badge: "Premium")` on the Subscription row, rendered by `ProfileView.settingRow` as an `AccentPill` in `AppColor.gold`. |
| `isPremium` flag | `Features/Profile/Domain/Entities/UserProfileModel.swift` | Field on `UserProfileModel`. The sample user has `isPremium: true`. No UI surface reads this field today. |
| Subscription mention in sample data | "Premium Annual" plan name + "Best Value" badge inside `SubscriptionView`. | All values are hard-coded inside the view (`$59.99`, `Jan 14, 2027`, etc.). |

## `SubscriptionView` Composition

A single `SettingsScreen(title: "Subscription")` containing:

1. **Hero card** — gold-tinted `GradientCard`-style ZStack with `AccentPill("Premium · Active")`, "Cobrasthenics" + gold "Premium" wordmarks, and three monospaced premium stats (`Plan: Annual`, `Member since: Jan 2026`, `Next billing: Jan 14, 2027`).
2. **Billing** — `SettingsListGroup` with three `SettingsListRow`s: Apple App Store, Next charge (`$59.99`), Auto-renew (with `AppToggle`).
3. **What's unlocked** — `AppCard` listing six benefits with green check icons.
4. **Change plan** — two `planCard` buttons (`Premium Monthly`, `Premium Annual` with "Best Value" badge).
5. **Manage** — `SettingsListGroup` linking to Manage in App Store / Billing history / Restore purchases.
6. **Cancel** — red-tinted `AppCard` "Cancel subscription" row.

All actions are layout-only — no closures wired to purchase, restore, or cancel flows.

## Product Rules

When real subscriptions are implemented, code must:

- Use direct, concrete copy. No hype or exaggerated claims.
- Use `AppColor.brand` for primary subscription actions (the current view uses `AppColor.gold` for hero accents because gold is the entitlement accent; see `Docs/Design/ui_rules.md` §2.2).
- Reserve the full COBRA / STHENICS wordmark for splash and the subscription hero only.

## Entitlement States To Model

When `SubscriptionRepository` is added, plan for:

- `unknown` / `loading`
- `free`
- `trial`
- `activeSubscriber`
- `expired`
- `billingIssue`

## Feature Gating

Feature gates should:

- Explain what is unavailable and what the next action is.
- Avoid blocking unrelated navigation.
- Use `PrimaryButton` for the upgrade CTA.

## Future Backend Boundary

The future production layer (see `Docs/Architecture/backend_architecture.md`):

```text
Features/Subscription/
├── Domain/
│   ├── Entities/Entitlement.swift          (state, renewalDate, productID, …)
│   └── Repositories/SubscriptionRepository.swift
├── Data/
│   └── Repositories/
│       ├── StoreKitSubscriptionRepository.swift     // or RevenueCat-backed
│       └── SampleSubscriptionRepository.swift
└── Presentation/
    ├── ViewModels/SubscriptionViewModel.swift
    └── Views/PaywallView.swift                       // not the current SubscriptionView
```

`SubscriptionView` (the current Settings screen) will then read entitlement state from a `SubscriptionViewModel` instead of hard-coded layout values. `AppEnvironment` will gain a `subscriptionRepository: any SubscriptionRepository` property.

## Not Yet Implemented

- Paywall screen with feature comparison.
- Restore purchases handler.
- Server-validated entitlement.
- Promotional offer codes.
- Grace period logic.
- 7-day free trial flow.

All of the above are described in `Docs/Product/product_spec.md` §3.10 as planned work.
