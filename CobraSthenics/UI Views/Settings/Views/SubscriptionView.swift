import SwiftUI

public struct SubscriptionView: View {
    @State private var selectedPlan: String = "annual"
    @State private var autoRenew = true

    public init() {}

    public var body: some View {
        SettingsScreen(title: SettingsConstants.Subscription.title) {
            heroCard
                .padding(.top, AppSpacing.md)

            SettingsListHeader(SettingsConstants.Subscription.billingHeader)
            SettingsListGroup {
                SettingsListRow(
                    systemImage: "creditcard",
                    iconColor: AppColor.brand,
                    label: SettingsConstants.Subscription.appStoreLabel,
                    sub: SettingsConstants.Subscription.appStoreSub
                )
                SettingsListRow(
                    systemImage: "calendar",
                    iconColor: AppColor.brand,
                    label: SettingsConstants.Subscription.nextChargeLabel,
                    sub: "$59.99 USD on Jan 14, 2027"
                ) {
                    Text("$59.99")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(AppColor.textPrimary)
                }
                SettingsListRow(
                    systemImage: "arrow.triangle.2.circlepath",
                    iconColor: AppColor.brand,
                    label: SettingsConstants.Subscription.autoRenewLabel,
                    sub: autoRenew ? SettingsConstants.Subscription.autoRenewOn : "\(SettingsConstants.Subscription.autoRenewOffPrefix)Jan 14, 2027",
                    showsDivider: false
                ) {
                    AppToggle(isOn: $autoRenew)
                }
            }

            SettingsListHeader(SettingsConstants.Subscription.unlockedHeader)
            unlockedCard

            SettingsListHeader(SettingsConstants.Subscription.changePlanHeader)
            VStack(spacing: AppSpacing.xs) {
                planCard(
                    name: SettingsConstants.Subscription.monthlyName,
                    price: SettingsConstants.Subscription.monthlyPrice,
                    period: SettingsConstants.Subscription.monthlyPeriod,
                    subline: nil,
                    badge: nil,
                    id: "monthly"
                )
                planCard(
                    name: SettingsConstants.Subscription.annualName,
                    price: SettingsConstants.Subscription.annualPrice,
                    period: SettingsConstants.Subscription.annualPeriod,
                    subline: SettingsConstants.Subscription.annualSubline,
                    badge: SettingsConstants.Subscription.bestValueBadge,
                    id: "annual"
                )
            }

            SettingsListHeader(SettingsConstants.Subscription.manageHeader)
            SettingsListGroup {
                SettingsListRow(systemImage: "arrow.up.right.square", iconColor: AppColor.brand,
                                label: SettingsConstants.Subscription.manageAppStoreLabel, sub: SettingsConstants.Subscription.manageAppStoreSub)
                SettingsListRow(systemImage: "doc.text", iconColor: AppColor.brand, label: SettingsConstants.Subscription.billingHistoryLabel)
                SettingsListRow(systemImage: "arrow.counterclockwise", iconColor: AppColor.brand,
                                label: SettingsConstants.Subscription.restoreLabel, showsDivider: false)
            }

            SettingsListHeader(SettingsConstants.Subscription.cancelHeader)
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
                        Text(SettingsConstants.Subscription.cancelLabel)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(AppColor.red)
                        Text("\(SettingsConstants.Subscription.cancelSubPrefix)Jan 14, 2027")
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
                        AccentPill(SettingsConstants.Subscription.premiumActiveBadge, color: AppColor.gold)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(SettingsConstants.Subscription.brandTitle)
                                .font(.system(size: 26, weight: .black))
                                .foregroundStyle(.white)
                            Text(SettingsConstants.Subscription.premiumWord)
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
                    premStat(SettingsConstants.Subscription.planLabel, "Annual")
                    premStat(SettingsConstants.Subscription.memberSinceLabel, "Jan 2026")
                    premStat(SettingsConstants.Subscription.nextBillingLabel, "Jan 14, 2027")
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
