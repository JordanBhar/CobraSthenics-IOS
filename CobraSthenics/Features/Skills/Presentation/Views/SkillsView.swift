import SwiftUI

public struct SkillsView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var viewModel: SkillsViewModel

    public init(viewModel: SkillsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    AppHeader(
                        eyebrow: "Progression",
                        title: "Skills",
                        subtitle: "\(viewModel.count(.active)) active · \(viewModel.count(.locked)) locked · \(viewModel.count(.mastered)) mastered"
                    )
                    statsRow
                    FilterChips(
                        options: viewModel.families,
                        selected: viewModel.selectedFamily,
                        label: { $0 == "all" ? "All Skills" : $0.prefix(1).uppercased() + String($0.dropFirst()) },
                        onSelect: { viewModel.selectedFamily = $0 }
                    )
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(viewModel.filteredSkills) { skill in
                            NavigationLink {
                                SkillDetailView(skill: skill, skillRepository: environment.skillRepository)
                            } label: {
                                SkillCard(skill: skill)
                            }
                            .buttonStyle(.plain)
                            .disabled(skill.status == .locked)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppLayout.bottomBarClearance)
            }
        }
        .task { await viewModel.load() }
        .appNavigationBarHidden(true)
    }

    private var statsRow: some View {
        HStack(spacing: AppSpacing.xs) {
            statCard("bolt.fill", value: "\(viewModel.count(.active))", label: "Active", color: AppColor.brand)
            statCard("calendar", value: "47", label: "Sessions", color: AppColor.green)
            statCard("trophy.fill", value: "12", label: "PRs Set", color: AppColor.gold)
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

struct SkillCard: View {
    let skill: SkillModel

    var body: some View {
        let locked = skill.status == .locked
        AppCard(padding: 0, border: locked ? AppColor.border : skill.accent.opacity(0.22)) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(LinearGradient(colors: skill.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .stroke(skill.accent.opacity(0.25), lineWidth: 1)
                            Image(systemName: locked ? "lock.fill" : "target")
                                .foregroundStyle(skill.accent)
                                .font(.system(size: 20))
                        }
                        .frame(width: 52, height: 52)

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(skill.name)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(AppColor.textPrimary)
                                Spacer()
                                if !locked {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(AppColor.textHint)
                                }
                            }
                            Text(locked
                                 ? "Complete prerequisites to unlock"
                                 : "Tier \(skill.tierIndex) of \(skill.totalTiers) · \(skill.currentTier)")
                                .font(.appCaption)
                                .foregroundStyle(locked ? AppColor.textHint : AppColor.textSecondary)
                            TierDots(current: skill.tierIndex, total: skill.totalTiers, accent: skill.accent)
                                .padding(.top, 2)
                        }
                    }

                    if !locked {
                        HStack(spacing: 10) {
                            statTile("BEST", value: skill.bestDisplay ?? "—", color: skill.accent)
                            statTile("TARGET", value: skill.target, color: AppColor.textSecondary)
                            progressTile
                        }
                    }
                }
                .padding(AppSpacing.md)
                .opacity(locked ? 0.55 : 1)

                if !locked {
                    Rectangle().fill(AppColor.border).frame(height: 1)
                    HStack(spacing: AppSpacing.xs) {
                        actionTile("Train", systemImage: "play.fill", color: skill.accent, filled: true)
                            .frame(maxWidth: .infinity)
                        actionTile("Analyse Form", systemImage: "camera", color: skill.accent, filled: false)
                            .frame(maxWidth: .infinity * 2)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                }
            }
        }
    }

    private func statTile(_ label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(1)
                .foregroundStyle(AppColor.textHint)
            Text(value)
                .font(.system(size: 17, weight: .black, design: .monospaced))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(AppColor.elevated)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var progressTile: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("PROGRESS")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(1)
                .foregroundStyle(AppColor.textHint)
            AppProgressBar(progress: Double(skill.progressPercent) / 100, color: skill.accent, height: 6)
            Text("\(skill.progressPercent)%")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(skill.accent)
        }
        .frame(maxWidth: .infinity * 2, alignment: .leading)
        .padding(10)
        .background(AppColor.elevated)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func actionTile(_ title: String, systemImage: String, color: Color, filled: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage).font(.system(size: 13, weight: .bold))
            Text(title.uppercased())
                .font(.system(size: 11, weight: .heavy))
                .tracking(0.6)
        }
        .foregroundStyle(filled ? .white : color)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(filled ? color : color.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .stroke(filled ? Color.clear : color.opacity(0.32), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        SkillsView(viewModel: SkillsViewModel(skillRepository: SampleSkillRepository()))
    }
    .environment(AppEnvironment.preview)
}
