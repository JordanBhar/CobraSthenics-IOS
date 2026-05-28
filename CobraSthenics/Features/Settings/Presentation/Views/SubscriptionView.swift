import SwiftUI

public struct SubscriptionView: View {
    @State private var selectedPlan: String = "annual"
    @State private var autoRenew = true

    public init() {}

    public var body: some View {
        SettingsScreen(title: "Subscription") {
            heroCard
                .padding(.top, AppSpacing.md)

            SettingsListHeader("Billing")
            SettingsListGroup {
                SettingsListRow(
                    systemImage: "creditcard",
                    iconColor: AppColor.brand,
                    label: "Apple App Store",
                    sub: "Renews via App Store · Apple ID purchase"
                )
                SettingsListRow(
                    systemImage: "calendar",
                    iconColor: AppColor.brand,
                    label: "Next charge",
                    sub: "$59.99 USD on Jan 14, 2027"
                ) {
                    Text("$59.99")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(AppColor.textPrimary)
                }
                SettingsListRow(
                    systemImage: "arrow.triangle.2.circlepath",
                    iconColor: AppColor.brand,
                    label: "Auto-renew",
                    sub: autoRenew ? "Renews automatically" : "Will end on Jan 14, 2027",
                    showsDivider: false
                ) {
                    AppToggle(isOn: $autoRenew)
                }
            }

            SettingsListHeader("What's unlocked")
            unlockedCard

            SettingsListHeader("Change plan")
            VStack(spacing: AppSpacing.xs) {
                planCard(
                    name: "Premium Monthly",
                    price: "$9.99",
                    period: "per month",
                    subline: nil,
                    badge: nil,
                    id: "monthly"
                )
                planCard(
                    name: "Premium Annual",
                    price: "$59.99",
                    period: "per year",
                    subline: "$5.00/mo — save 50%",
                    badge: "Best Value",
                    id: "annual"
                )
            }

            SettingsListHeader("Manage")
            SettingsListGroup {
                SettingsListRow(systemImage: "arrow.up.right.square", iconColor: AppColor.brand,
                                label: "Manage in App Store", sub: "Update payment, change plan, restore")
                SettingsListRow(systemImage: "doc.text", iconColor: AppColor.brand, label: "Billing history")
                SettingsListRow(systemImage: "arrow.counterclockwise", iconColor: AppColor.brand,
                                label: "Restore purchases", showsDivider: false)
            }

            SettingsListHeader("Cancel")
            AppCard(background: AppColor.red.opacity(0.04), border: AppColor.red.opacity(0.18)) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .fill(AppColor.red.opacity(0.14))
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .stroke(AppColor.red.opacity(0.3), lineWidth: 1)
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 13))
                            .foregroundStyle(AppColor.red)
                    }
                    .frame(width: 30, height: 30)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Cancel subscription")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(AppColor.red)
                        Text("Premium access continues until Jan 14, 2027")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppColor.textSecondary)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColor.textHint)
                }
            }
            .padding(.bottom, AppSpacing.xl)
        }
    }

    private var heroCard: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: 0x1A1200), Color(hex: 0x3A2400)], startPoint: .topLeading, endPoint: .bottomTrailing)
            RadialGradient(
                gradient: Gradient(colors: [AppColor.gold.opacity(0.18), .clear]),
                center: UnitPoint(x: 0.8, y: -0.1),
                startRadius: 10, endRadius: 280
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        AccentPill("Premium · Active", color: AppColor.gold)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Cobrasthenics")
                                .font(.system(size: 26, weight: .black))
                                .foregroundStyle(.white)
                            Text("Premium")
                                .font(.system(size: 26, weight: .black))
                                .foregroundStyle(AppColor.gold)
                        }
                    }
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColor.gold.opacity(0.18))
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppColor.gold.opacity(0.35), lineWidth: 1)
                        Image(systemName: "star.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(AppColor.gold)
                    }
                    .frame(width: 48, height: 48)
                }
                HStack(spacing: AppSpacing.xs) {
                    premStat("Plan", "Annual")
                    premStat("Member since", "Jan 2026")
                    premStat("Next billing", "Jan 14, 2027")
                }
            }
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(AppColor.gold.opacity(0.25), lineWidth: 1)
        )
    }

    private func premStat(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .bold))
                .tracking(1)
                .foregroundStyle(.white.opacity(0.45))
            Text(value)
                .font(.system(size: 14, weight: .black, design: .monospaced))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var unlockedCard: some View {
        let rows: [(icon: String, label: String)] = [
            ("video.fill", "Video demonstrations for 400+ exercises"),
            ("infinity", "Unlimited progress photos"),
            ("chart.line.uptrend.xyaxis", "Skill analytics + hold-time trends"),
            ("chart.bar.fill", "Advanced training-volume charts"),
            ("wrench.and.screwdriver.fill", "Custom program builder"),
            ("moon.fill", "AI recovery suggestions")
        ]
        return AppCard(padding: 8) {
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(AppColor.green.opacity(0.14))
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(AppColor.green.opacity(0.3), lineWidth: 1)
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(AppColor.green)
                        }
                        .frame(width: 26, height: 26)
                        Text(row.label)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AppColor.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 10)
                }
            }
        }
    }

    private func planCard(name: String, price: String, period: String, subline: String?, badge: String?, id: String) -> some View {
        let selected = selectedPlan == id
        return Button {
            selectedPlan = id
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(selected ? AppColor.gold : AppColor.textHint, lineWidth: 2)
                        .background(Circle().fill(selected ? AppColor.gold : Color.clear))
                    if selected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.black)
                    }
                }
                .frame(width: 22, height: 22)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(name)
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundStyle(AppColor.textPrimary)
                        if let badge {
                            Text(badge.uppercased())
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .tracking(0.8)
                                .foregroundStyle(AppColor.gold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(AppColor.gold.opacity(0.14))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(AppColor.gold.opacity(0.3), lineWidth: 1))
                        }
                    }
                    if let subline {
                        Text(subline)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppColor.green)
                    }
                }
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 4) {
                    Text(price)
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundStyle(AppColor.textPrimary)
                    Text(period.uppercased())
                        .font(.system(size: 10, weight: .medium))
                        .tracking(0.8)
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
            .padding(16)
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                    .stroke(selected ? AppColor.gold : AppColor.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SubscriptionView()
    }
}
