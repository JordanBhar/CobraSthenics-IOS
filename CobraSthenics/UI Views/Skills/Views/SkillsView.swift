import SwiftUI
import SwiftData

public struct SkillsView: View {

    @Query(sort: \Skill.name) private var skills: [Skill]
    @State private var viewModel = SkillsViewModel()

    public init() {}

    private var visibleSkills: [Skill] { viewModel.visibleSkills(from: skills) }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    AppHeader(
                        eyebrow: SkillsConstants.Header.eyebrow,
                        title: SkillsConstants.Header.title,
                        subtitle: "\(skills.count) \(skills.count == 1 ? "skill" : "skills") in progression"
                    )
                    statsRow
                    FilterChips(
                        options: viewModel.familyOptions,
                        selected: viewModel.selectedFamily,
                        label: { $0?.displayName ?? SkillsConstants.Filters.allSkills },
                        onSelect: { viewModel.selectedFamily = $0 }
                    )
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(visibleSkills) { skill in
                            NavigationLink {
                                SkillDetailView(skill: skill)
                            } label: {
                                SkillCard(skill: skill)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppLayout.bottomBarClearance)
            }
        }
        .appNavigationBarHidden(true)
    }

    private var statsRow: some View {
        HStack(spacing: AppSpacing.xs) {
            statCard(SkillsConstants.Stats.activeIcon, value: "\(skills.count)", label: SkillsConstants.Stats.activeLabel, color: AppColor.brand)
            statCard(SkillsConstants.Stats.sessionsIcon, value: SkillsConstants.Stats.sessionsValue, label: SkillsConstants.Stats.sessionsLabel, color: AppColor.green)
            statCard(SkillsConstants.Stats.prsIcon, value: SkillsConstants.Stats.prsValue, label: SkillsConstants.Stats.prsLabel, color: AppColor.gold)
        }
    }

    private func statCard(_ icon: String, value: String, label: String, color: Color) -> some View {
        AppCard(padding: 14) {
            VStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color)
                Text(value)
                    .font(.system(size: 20, weight: .black, design: .monospaced))
                    .foregroundStyle(AppColor.textPrimary)
                Text(label.uppercased())
                    .font(.appCaption)
                    .tracking(0.6)
                    .foregroundStyle(AppColor.textHint)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        SkillsView()
    }
    .modelContainer(PreviewModelContainer.shared)
}
