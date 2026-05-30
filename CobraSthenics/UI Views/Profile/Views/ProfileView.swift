import SwiftUI
import SwiftData

public struct ProfileView: View {

    @Query private var users: [User]
    @Query(sort: \PersonalRecord.updatedAt, order: .reverse) private var personalRecords: [PersonalRecord]

    @State private var viewModel = ProfileViewModel()

    public init() {}

    private var user: User? { users.first }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            if let user {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        userCard(user)
                        quickStats(user)
                        achievementsGrid(user.achievements)
                        personalRecordsList
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
        .appNavigationBarHidden(true)
    }

    private func userCard(_ user: User) -> some View {
        let level = user.level
        let title = user.levelTitle
        let currentXP = user.currentXP
        let xpToNext = user.xpToNextLevel
        let progress = user.xpProgress
        return AppCard(padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 14) {
                    avatar(user)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.displayName ?? user.username)
                            .font(.system(size: 19, weight: .black))
                            .foregroundStyle(AppColor.textPrimary)
                        Text("\(ProfileConstants.usernamePrefix)\(user.username) · \(ProfileConstants.levelAbbreviation) \(level) \(title)")
                            .font(.appCaption)
                            .foregroundStyle(AppColor.textHint)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: ProfileConstants.settingsIcon)
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
                        Text("\(ProfileConstants.XP.labelPrefix) \(level + 1)")
                            .font(.appLabel)
                            .tracking(0.6)
                            .foregroundStyle(AppColor.textSecondary)
                        Spacer()
                        Text("\(currentXP.formatted()) \(ProfileConstants.XP.separator) \(xpToNext.formatted())")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundStyle(AppColor.gold)
                    }
                    AppProgressBar(progress: progress, color: AppColor.gold, height: 6)
                }
            }
        }
    }

    private func avatar(_ user: User) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: 0x001D42), Color(hex: 0x003E8A)], startPoint: .topLeading, endPoint: .bottomTrailing))
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColor.brand.opacity(0.3), lineWidth: 1)
            Text(viewModel.initials(for: user.displayName ?? user.username))
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(.white)
        }
        .frame(width: 64, height: 64)
    }

    private func quickStats(_ user: User) -> some View {
        HStack(spacing: AppSpacing.xs) {
            statTile(value: "\(user.workoutCount)", label: ProfileConstants.QuickStats.workouts, color: AppColor.textPrimary)
            statTile(value: "\(user.streakDays)", label: ProfileConstants.QuickStats.dayStreak, color: AppColor.gold)
            statTile(value: "\(user.activeSkillsCount)", label: ProfileConstants.QuickStats.skills, color: AppColor.green)
            statTile(value: "\(user.personalRecordCount)", label: ProfileConstants.QuickStats.personalRecords, color: AppColor.brand)
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

    private func achievementsGrid(_ achievements: [Achievement]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            SectionHeader(ProfileConstants.Achievements.sectionTitle, actionTitle: ProfileConstants.Achievements.sectionAction)
            if achievements.isEmpty {
                AppCard {
                    Text(ProfileConstants.Achievements.emptyMessage)
                        .font(.appBody)
                        .foregroundStyle(AppColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.sm)
                }
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: AppSpacing.xs),
                    GridItem(.flexible(), spacing: AppSpacing.xs),
                    GridItem(.flexible(), spacing: AppSpacing.xs)
                ], spacing: AppSpacing.xs) {
                    ForEach(achievements) { achievement in
                        AppCard(padding: 12) {
                            VStack(spacing: 6) {
                                Text(achievement.iconSymbol)
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
    }

    private var personalRecordsList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            SectionHeader(ProfileConstants.PersonalRecords.sectionTitle, actionTitle: ProfileConstants.PersonalRecords.sectionAction)
            if personalRecords.isEmpty {
                AppCard {
                    Text(ProfileConstants.PersonalRecords.emptyMessage)
                        .font(.appBody)
                        .foregroundStyle(AppColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.sm)
                }
            } else {
                VStack(spacing: AppSpacing.xs) {
                    ForEach(personalRecords) { pr in
                        prTile(pr)
                    }
                }
            }
        }
    }

    private func prTile(_ pr: PersonalRecord) -> some View {
        let accent = viewModel.prAccent(for: pr)
        return AppCard(padding: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(accent.opacity(0.18))
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(accent.opacity(0.3), lineWidth: 1)
                    Image(systemName: ProfileConstants.PersonalRecords.trophyIcon)
                        .font(.system(size: 12))
                        .foregroundStyle(accent)
                }
                .frame(width: 32, height: 32)
                Text(pr.exercise.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                Spacer()
                Text(viewModel.prValueDisplay(for: pr))
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundStyle(accent)
            }
        }
    }

    private var settingsGroups: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(ProfileConstants.Settings.sectionTitle)
            ForEach(SettingsCatalog.groups) { group in
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

    private func settingRow(_ item: SettingItemPresentationModel, showsDivider: Bool) -> some View {
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
                    Image(systemName: ProfileConstants.Settings.chevronIcon)
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
        ProfileView()
    }
    .modelContainer(PreviewModelContainer.shared)
}
