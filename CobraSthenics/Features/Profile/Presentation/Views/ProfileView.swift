import SwiftUI

public struct ProfileView: View {
    @Environment(AppEnvironment.self) private var appEnvironment
    @State private var viewModel: ProfileViewModel

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            if let snapshot = viewModel.snapshot {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        userCard(snapshot.user)
                        quickStats(snapshot.user)
                        achievements(snapshot.user.achievements)
                        personalRecords(snapshot.personalRecords)
                        settingsGroups
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppLayout.bottomBarClearance)
                }
            } else {
                ProgressView().tint(AppColor.brand)
            }
        }
        .task { await viewModel.load() }
        .appNavigationBarHidden(true)
    }

    private func userCard(_ user: UserProfileModel) -> some View {
        AppCard(padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 14) {
                    avatar(user)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.displayName)
                            .font(.system(size: 19, weight: .black))
                            .foregroundStyle(AppColor.textPrimary)
                        Text("@\(user.username) · Lvl \(user.level) \(user.levelTitle)")
                            .font(.appCaption)
                            .foregroundStyle(AppColor.textHint)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "gearshape")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColor.textSecondary)
                        .frame(width: 36, height: 36)
                        .background(AppColor.elevated)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                                .stroke(AppColor.border, lineWidth: 1)
                        )
                }
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("XP TO LVL \(user.level + 1)")
                            .font(.appLabel)
                            .tracking(0.6)
                            .foregroundStyle(AppColor.textSecondary)
                        Spacer()
                        Text("\(user.currentXP.formatted()) / \(user.xpToNextLevel.formatted())")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundStyle(AppColor.gold)
                    }
                    AppProgressBar(progress: user.xpProgress, color: AppColor.gold, height: 6)
                }
            }
        }
    }

    private func avatar(_ user: UserProfileModel) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: 0x001D42), Color(hex: 0x003E8A)], startPoint: .topLeading, endPoint: .bottomTrailing))
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColor.brand.opacity(0.3), lineWidth: 1)
            Text(initials(user.displayName))
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(.white)
        }
        .frame(width: 64, height: 64)
    }

    private func initials(_ name: String) -> String {
        let parts = name.components(separatedBy: " ").filter { !$0.isEmpty }
        let firsts = parts.prefix(2).compactMap { $0.first.map(String.init) }
        return firsts.joined().uppercased()
    }

    private func quickStats(_ user: UserProfileModel) -> some View {
        HStack(spacing: AppSpacing.xs) {
            statTile(value: "\(user.workoutCount)", label: "Workouts", color: AppColor.textPrimary)
            statTile(value: "\(user.streakDays)", label: "Day streak", color: AppColor.gold)
            statTile(value: "\(user.activeSkills)", label: "Skills", color: AppColor.green)
            statTile(value: "\(user.prCount)", label: "PRs", color: AppColor.brand)
        }
    }

    private func statTile(value: String, label: String, color: Color) -> some View {
        AppCard(padding: 12) {
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .black, design: .monospaced))
                    .foregroundStyle(color)
                Text(label)
                    .font(.appCaption)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func achievements(_ achievements: [Achievement]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            SectionHeader("Achievements", actionTitle: "All")
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: AppSpacing.xs),
                GridItem(.flexible(), spacing: AppSpacing.xs),
                GridItem(.flexible(), spacing: AppSpacing.xs)
            ], spacing: AppSpacing.xs) {
                ForEach(achievements) { achievement in
                    AppCard(padding: 12) {
                        VStack(spacing: 6) {
                            Text(achievement.emoji)
                                .font(.system(size: 22))
                            Text(achievement.name)
                                .font(.appCaption)
                                .foregroundStyle(achievement.isEarned ? AppColor.textPrimary : AppColor.textHint)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .opacity(achievement.isEarned ? 1 : 0.4)
                }
            }
        }
    }

    private func personalRecords(_ records: [PrEntry]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            SectionHeader("Personal Records", actionTitle: "All PRs")
            VStack(spacing: AppSpacing.xs) {
                ForEach(records) { pr in
                    AppCard(padding: 14) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(pr.accent.opacity(0.18))
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(pr.accent.opacity(0.3), lineWidth: 1)
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(pr.accent)
                            }
                            .frame(width: 32, height: 32)
                            Text(pr.exerciseName)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(AppColor.textPrimary)
                            Spacer()
                            Text(pr.valueDisplay)
                                .font(.system(size: 18, weight: .black, design: .monospaced))
                                .foregroundStyle(pr.accent)
                        }
                    }
                }
            }
        }
    }

    private var settingsGroups: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader("Settings")
            ForEach(viewModel.settingGroups) { group in
                AppCard(padding: 0) {
                    VStack(spacing: 0) {
                        ForEach(Array(group.items.enumerated()), id: \.element.id) { index, item in
                            settingRow(item, showsDivider: index < group.items.count - 1)
                        }
                    }
                }
            }
        }
    }

    private func settingRow(_ item: SettingItemModel, showsDivider: Bool) -> some View {
        NavigationLink {
            destination(for: item.route)
        } label: {
            HStack(spacing: AppSpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(item.color.opacity(0.14))
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .stroke(item.color.opacity(0.3), lineWidth: 1)
                    Image(systemName: item.systemImage)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(item.color)
                }
                .frame(width: 30, height: 30)
                Text(item.label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(item.destructive ? AppColor.red : AppColor.textPrimary)
                Spacer(minLength: AppSpacing.sm)
                if let value = item.value {
                    Text(value)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColor.textSecondary)
                }
                if let badge = item.badge {
                    AccentPill(badge, color: AppColor.gold)
                }
                if !item.destructive {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColor.textHint)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay(alignment: .bottom) {
                if showsDivider {
                    Rectangle()
                        .fill(AppColor.border)
                        .frame(height: 1)
                        .padding(.leading, 56)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(item.route == .none)
    }

    @ViewBuilder
    private func destination(for route: SettingsRoute) -> some View {
        switch route {
        case .notifications: NotificationsSettingsView()
        case .workoutReminders: WorkoutRemindersView()
        case .restTimer: RestTimerSettingsView()
        case .appearance: AppearanceSettingsView()
        case .language: LanguageSettingsView()
        case .editProfile: EditProfileView()
        case .changePassword: ChangePasswordView()
        case .connectedApps: ConnectedAppsView()
        case .exportData: ExportDataView()
        case .helpFAQ: HelpFAQView()
        case .feedback: SendFeedbackView()
        case .deleteAccount: DeleteAccountView()
        case .subscription: SubscriptionView()
        case .none: EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(viewModel: ProfileViewModel(
            userRepository: SampleUserRepository(),
            settingsRepository: SampleSettingsRepository()
        ))
    }
    .environment(AppEnvironment.preview)
}
