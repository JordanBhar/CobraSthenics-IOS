import SwiftUI

public struct SkillDetailView: View {
    public let skill: SkillModel
    public let skillRepository: any SkillRepository

    @State private var selectedTab: SkillDetailTab = .instructions
    @State private var history: [SkillSessionEntry] = []

    public init(skill: SkillModel, skillRepository: any SkillRepository) {
        self.skill = skill
        self.skillRepository = skillRepository
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    hero
                    VStack(spacing: AppSpacing.md) {
                        statsRow
                        tierCard
                        tabSelector
                        tabContent
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, 130)
                }
            }
            .ignoresSafeArea(edges: .top)
            ctaBar
        }
        .task {
            history = (try? await skillRepository.getSkillHistory(skillName: skill.name)) ?? []
        }
        .appNavigationBarTitleDisplayModeInline()
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .topLeading) {
            BackChromeButton()
                .padding(.top, 12)
                .padding(.leading, AppSpacing.md)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            AccentPill("\(skill.family.uppercased()) · TIER \(skill.tierIndex) OF \(skill.totalTiers)", color: skill.accent)
            Text(skill.name)
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(.white)
            Text("\(skill.currentTier) → \(skill.nextTier)")
                .font(.appBody)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, 100)
        .padding(.bottom, AppSpacing.xl)
        .background(
            ZStack {
                LinearGradient(colors: skill.colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(
                    gradient: Gradient(colors: [skill.accent.opacity(0.22), .clear]),
                    center: UnitPoint(x: 0.82, y: -0.1),
                    startRadius: 10, endRadius: 280
                )
                .allowsHitTesting(false)
            }
        )
    }

    private var statsRow: some View {
        HStack(spacing: AppSpacing.xs) {
            detailStat("Best", skill.bestDisplay ?? "—", color: skill.accent)
            detailStat("Target", skill.target, color: AppColor.textSecondary)
            detailStat("Progress", "\(skill.progressPercent)%", color: skill.accent)
        }
    }

    private func detailStat(_ label: String, _ value: String, color: Color) -> some View {
        AppCard(padding: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label.uppercased())
                    .font(.appLabel)
                    .tracking(0.8)
                    .foregroundStyle(AppColor.textHint)
                Text(value)
                    .font(.system(size: 17, weight: .black, design: .monospaced))
                    .foregroundStyle(color)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var tierCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text("Tier Progress · \(skill.tierIndex) of \(skill.totalTiers)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                    Spacer()
                    Text(skill.currentTier.uppercased())
                        .font(.appLabel)
                        .tracking(0.6)
                        .foregroundStyle(skill.accent)
                }
                TierDots(current: skill.tierIndex, total: skill.totalTiers, accent: skill.accent)
            }
        }
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(SkillDetailTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(AppAnimation.quick) { selectedTab = tab }
                } label: {
                    Text(tab.title)
                        .font(.system(size: 11, weight: selectedTab == tab ? .bold : .medium))
                        .tracking(0.6)
                        .foregroundStyle(selectedTab == tab ? AppColor.textPrimary : AppColor.textHint)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(selectedTab == tab ? AppColor.elevated2 : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .instructions: instructionsList
        case .muscles: muscles
        case .history: historyList
        }
    }

    private var instructionsList: some View {
        VStack(spacing: AppSpacing.xs) {
            ForEach(Array(skill.instructions.enumerated()), id: \.offset) { index, step in
                AppCard(padding: 14) {
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .fill(skill.accent.opacity(0.18))
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .stroke(skill.accent.opacity(0.35), lineWidth: 1)
                            Text(String(format: "%02d", index + 1))
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(skill.accent)
                        }
                        .frame(width: 26, height: 26)
                        Text(step)
                            .font(.system(size: 13))
                            .foregroundStyle(AppColor.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private var muscles: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            muscleSection("Primary Muscles", items: skill.primaryMuscles, color: skill.accent)
            muscleSection("Secondary Muscles", items: skill.secondaryMuscles, color: AppColor.textSecondary, outline: true)
            if skill.isStaticHold {
                AppCard(background: skill.accent.opacity(0.08), border: skill.accent.opacity(0.25)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("HOLD TYPE")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(skill.accent)
                        Text("Static isometric hold — sustained position under maximal tension. Build hold time progressively before advancing tier.")
                            .font(.appBody)
                            .foregroundStyle(AppColor.textPrimary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func muscleSection(_ title: String, items: [String], color: Color, outline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title.uppercased())
                .font(.appLabel)
                .tracking(0.8)
                .foregroundStyle(AppColor.textSecondary)
            FlowLayout(items: items, color: color, outline: outline)
        }
    }

    private var historyList: some View {
        VStack(spacing: AppSpacing.xs) {
            if history.isEmpty {
                AppCard { Text("No sessions logged yet").font(.appBody).foregroundStyle(AppColor.textSecondary) }
            } else {
                ForEach(history) { entry in
                    AppCard(
                        padding: 12,
                        background: entry.isPR ? skill.accent.opacity(0.05) : AppColor.card,
                        border: entry.isPR ? skill.accent.opacity(0.28) : AppColor.border
                    ) {
                        HStack(spacing: 10) {
                            if entry.isPR {
                                Text("PR")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .tracking(0.8)
                                    .foregroundStyle(skill.accent)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 2)
                                    .background(skill.accent.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            }
                            Text(entry.dateLabel.uppercased())
                                .font(.appLabel)
                                .tracking(0.6)
                                .foregroundStyle(entry.isPR ? AppColor.textPrimary : AppColor.textSecondary)
                            Spacer()
                            Text(entry.valueDisplay)
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundStyle(entry.isPR ? skill.accent : AppColor.textSecondary)
                        }
                    }
                }
            }
        }
    }

    private var ctaBar: some View {
        HStack(spacing: AppSpacing.xs) {
            PrimaryButton("Train Skill", systemImage: "play.fill", color: skill.accent)
            OutlineButton("Analyse Form", systemImage: "camera", color: skill.accent)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
        .background(
            LinearGradient(
                colors: [AppColor.background.opacity(0), AppColor.background],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

private enum SkillDetailTab: CaseIterable {
    case instructions, muscles, history
    var title: String {
        switch self {
        case .instructions: return "Instructions"
        case .muscles: return "Muscles"
        case .history: return "History"
        }
    }
}

struct BackChromeButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SkillDetailView(
            skill: SampleData.skills[0],
            skillRepository: SampleSkillRepository()
        )
    }
    .environment(AppEnvironment.preview)
}
