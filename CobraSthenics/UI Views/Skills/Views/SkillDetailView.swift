import SwiftUI
import SwiftData

public struct SkillDetailView: View {

    let skill: Skill

    @State private var viewModel = SkillDetailViewModel()

    init(skill: Skill) {
        self.skill = skill
    }

    private var accent: Color { skill.family.accent }
    private var colors: [Color] { skill.family.colors }

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
            AccentPill("\(skill.family.displayName.uppercased()) · TIER \(skill.tierIndex) OF \(skill.totalTiers)", color: accent)
            Text(skill.name)
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(.white)
            Text(tierTransition)
                .font(.appBody)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, 100)
        .padding(.bottom, AppSpacing.xl)
        .background(
            ZStack {
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(
                    gradient: Gradient(colors: [accent.opacity(0.22), .clear]),
                    center: UnitPoint(x: 0.82, y: -0.1),
                    startRadius: 10, endRadius: 280
                )
                .allowsHitTesting(false)
            }
        )
    }

    private var tierTransition: String { viewModel.tierTransition(for: skill) }

    private var statsRow: some View {
        HStack(spacing: AppSpacing.xs) {
            detailStat("Best", SkillsConstants.Card.emptyValue, color: accent)
            detailStat("Target", skill.targetDisplay ?? SkillsConstants.Card.emptyValue, color: AppColor.textSecondary)
            detailStat("Progress", "0%", color: accent)
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
                    Text("\(SkillsConstants.Detail.tierProgressPrefix) · \(skill.tierIndex) of \(skill.totalTiers)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                    Spacer()
                    Text(skill.currentTierName.uppercased())
                        .font(.appLabel)
                        .tracking(0.6)
                        .foregroundStyle(accent)
                }
                TierDots(current: skill.tierIndex, total: skill.totalTiers, accent: accent)
            }
        }
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(SkillDetailViewModel.Tab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(AppAnimation.quick) { viewModel.selectedTab = tab }
                } label: {
                    Text(tab.title)
                        .font(.system(size: 11, weight: viewModel.selectedTab == tab ? .bold : .medium))
                        .tracking(0.6)
                        .foregroundStyle(viewModel.selectedTab == tab ? AppColor.textPrimary : AppColor.textHint)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(viewModel.selectedTab == tab ? AppColor.elevated2 : Color.clear)
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
        switch viewModel.selectedTab {
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
                                .fill(accent.opacity(0.18))
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .stroke(accent.opacity(0.35), lineWidth: 1)
                            Text(String(format: "%02d", index + 1))
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(accent)
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
            muscleSection(SkillsConstants.Detail.primaryMusclesTitle, items: skill.primaryMuscleGroups.map(\.displayName), color: accent)
            muscleSection(SkillsConstants.Detail.secondaryMusclesTitle, items: skill.secondaryMuscleGroups.map(\.displayName), color: AppColor.textSecondary, outline: true)
            if skill.isStaticHold {
                AppCard(background: accent.opacity(0.08), border: accent.opacity(0.25)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(SkillsConstants.Detail.holdTypeLabel)
                            .font(.system(size: 10, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(accent)
                        Text(SkillsConstants.Detail.holdTypeDescription)
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
        AppCard {
            Text(SkillsConstants.Detail.emptyHistoryMessage)
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
        }
    }

    private var ctaBar: some View {
        HStack(spacing: AppSpacing.xs) {
            PrimaryButton(SkillsConstants.Detail.ctaTrain, systemImage: SkillsConstants.Detail.ctaTrainIcon, color: accent)
            OutlineButton(SkillsConstants.Detail.ctaAnalyse, systemImage: SkillsConstants.Detail.ctaAnalyseIcon, color: accent)
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

#Preview {
    NavigationStack {
        PreviewSkillDetail()
    }
    .modelContainer(PreviewModelContainer.shared)
}

private struct PreviewSkillDetail: View {
    @Query(sort: \Skill.name) private var skills: [Skill]

    var body: some View {
        if let first = skills.first {
            SkillDetailView(skill: first)
        } else {
            Text("No seeded skills")
        }
    }
}
