import SwiftUI

public struct RestTimerSettingsView: View {
    @State private var seconds: Int = 120
    @State private var perCategory = false

    private let presets: [(label: String, seconds: Int)] = [
        ("45s", 45), ("1:00", 60), ("1:30", 90), ("2:00", 120), ("3:00", 180), ("5:00", 300)
    ]

    public init() {}

    public var body: some View {
        SettingsScreen(title: SettingsConstants.RestTimer.title, showsSaveCTA: true) {
            ringDisplay
                .padding(.top, AppSpacing.lg)
                .frame(maxWidth: .infinity, alignment: .center)

            SettingsListHeader(SettingsConstants.RestTimer.presetsHeader)
            FilterChips(
                options: presets.map(\.label),
                selected: matchingPreset() ?? "",
                label: { $0 },
                onSelect: { label in
                    if let preset = presets.first(where: { $0.label == label }) {
                        seconds = preset.seconds
                    }
                }
            )

            SettingsListHeader(SettingsConstants.RestTimer.customHeader)
            AppCard(padding: 14) {
                HStack {
                    stepperButton("minus") { seconds = max(15, seconds - 15) }
                    Spacer()
                    Text(formatted(seconds))
                        .font(.system(size: 30, weight: .black, design: .monospaced))
                        .foregroundStyle(AppColor.textPrimary)
                    Spacer()
                    stepperButton("plus") { seconds = min(600, seconds + 15) }
                }
            }

            SettingsListHeader(SettingsConstants.RestTimer.overridesHeader)
            SettingsListGroup {
                SettingsListRow(
                    systemImage: "square.stack.3d.up",
                    iconColor: AppColor.brand,
                    label: SettingsConstants.RestTimer.perCategoryLabel,
                    sub: SettingsConstants.RestTimer.perCategorySub,
                    showsDivider: false
                ) {
                    AppToggle(isOn: $perCategory)
                }
            }

            if perCategory {
                VStack(spacing: AppSpacing.xs) {
                    overrideRow(SettingsConstants.RestTimer.strengthOverride, value: "2:00", accent: AppColor.brand)
                    overrideRow(SettingsConstants.RestTimer.skillOverride, value: "3:00", accent: AppColor.green)
                    overrideRow(SettingsConstants.RestTimer.conditioningOverride, value: "1:00", accent: AppColor.red)
                }
                .padding(.top, AppSpacing.xs)
            }

            Text(SettingsConstants.RestTimer.footer)
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)
        }
    }

    private var ringDisplay: some View {
        ZStack {
            Circle().stroke(.white.opacity(0.06), lineWidth: 8)
            Circle()
                .trim(from: 0, to: Double(seconds) / 300.0)
                .stroke(AppColor.brand, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(AppAnimation.standard, value: seconds)
            VStack(spacing: 4) {
                Text(formatted(seconds))
                    .font(.system(size: 48, weight: .black, design: .monospaced))
                    .foregroundStyle(AppColor.textPrimary)
                Text(SettingsConstants.RestTimer.betweenSetsLabel)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .frame(width: 180, height: 180)
    }

    private func stepperButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle().fill(AppColor.elevated)
                Circle().stroke(AppColor.border, lineWidth: 1)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
            }
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
    }

    private func overrideRow(_ label: String, value: String, accent: Color) -> some View {
        AppCard(padding: 14) {
            HStack(spacing: 12) {
                Circle().fill(accent).frame(width: 8, height: 8)
                Text(label).font(.system(size: 14, weight: .semibold)).foregroundStyle(AppColor.textPrimary)
                Spacer()
                Image(systemName: "minus").font(.system(size: 12)).foregroundStyle(AppColor.textHint)
                Text(value)
                    .font(.system(size: 17, weight: .black, design: .monospaced))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(minWidth: 50)
                Image(systemName: "plus").font(.system(size: 12)).foregroundStyle(AppColor.textHint)
            }
        }
    }

    private func matchingPreset() -> String? {
        presets.first(where: { $0.seconds == seconds })?.label
    }

    private func formatted(_ s: Int) -> String {
        String(format: "%d:%02d", s / 60, s % 60)
    }
}

#Preview {
    NavigationStack {
        RestTimerSettingsView()
    }
}
