import SwiftUI
import SwiftData

public struct HomeView: View {

    @Query private var users: [User]
    @Query private var activeProgress: [UserProgramProgress]
    @Query(sort: \Skill.name) private var skills: [Skill]
    @Query(sort: \WorkoutSession.completedAt, order: .reverse) private var sessions: [WorkoutSession]

    @State private var viewModel = HomeViewModel()

    public init() {
        let progressPredicate = #Predicate<UserProgramProgress> { $0.isActive == true }
        _activeProgress = Query(filter: progressPredicate)
    }

    private var user: User? { users.first }
    private var activeProgramProgress: UserProgramProgress? { activeProgress.first }
    private var featuredSkill: Skill? { skills.first }
    private var recentCompletedSessions: [WorkoutSession] { viewModel.recentCompletedSessions(from: sessions) }
    private var weekDays: [WeekDay] { viewModel.weekDays(from: sessions) }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    greeting
                    dayStrip(weekDays)
                    streakRow(streak: user?.streakDays ?? 0)
                    if let progress = activeProgramProgress, let program = progress.program {
                        activeProgramCard(program: program, progress: progress)
                            .padding(.top, AppSpacing.xs)
                    }
                    if let skill = featuredSkill {
                        SectionHeader(HomeConstants.SkillFocus.sectionTitle, actionTitle: HomeConstants.SkillFocus.sectionAction)
                            .padding(.top, AppSpacing.xs)
                        skillFocusCard(skill)
                    }
                    SectionHeader(HomeConstants.RecentActivity.sectionTitle, actionTitle: HomeConstants.RecentActivity.sectionAction)
                        .padding(.top, AppSpacing.xs)
                    if recentCompletedSessions.isEmpty {
                        AppCard {
                            Text(HomeConstants.RecentActivity.emptyMessage)
                                .font(.appBody)
                                .foregroundStyle(AppColor.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.sm)
                        }
                    } else {
                        VStack(spacing: AppSpacing.xs) {
                            ForEach(recentCompletedSessions) { session in
                                recentSessionTile(session)
                            }
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

    private var greeting: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(HomeConstants.greeting)
                    .font(.appLabel)
                    .foregroundStyle(AppColor.textSecondary)
                Text(firstName)
                    .font(.appH1)
                    .foregroundStyle(AppColor.textPrimary)
            }
            Spacer()
            iconButton(systemImage: HomeConstants.notificationIcon)
        }
    }

    private var firstName: String { viewModel.firstName(for: user) }

    private func iconButton(systemImage: String) -> some View {
        Image(systemName: systemImage)
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

    private func dayStrip(_ days: [WeekDay]) -> some View {
        AppCard(padding: AppSpacing.sm) {
            HStack {
                ForEach(days) { day in
                    VStack(spacing: 5) {
                        Text(day.label)
                            .font(.system(size: 10, weight: .bold))
                            .tracking(0.8)
                            .foregroundStyle(dayLabelColor(day))
                        ZStack {
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .fill(day.completed ? AppColor.brand : AppColor.elevated)
                                .frame(width: 28, height: 28)
                            if day.isToday && !day.completed {
                                RoundedRectangle(cornerRadius: 9, style: .continuous)
                                    .stroke(AppColor.brand, lineWidth: 1)
                                    .frame(width: 28, height: 28)
                            }
                            if day.completed {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func dayLabelColor(_ day: WeekDay) -> Color {
        if day.completed { return AppColor.brand }
        if day.isToday { return AppColor.textPrimary }
        return AppColor.textHint
    }

    private func streakRow(streak: Int) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            GradientCard(colors: [Color(hex: 0x1A0C00), Color(hex: 0x2E1500)], accent: AppColor.gold, radius: AppRadius.md, padding: 14) {
                HStack(spacing: 10) {
                    Text(HomeConstants.Streak.emoji).font(.system(size: 24))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(streak)")
                            .font(.system(size: 22, weight: .black, design: .monospaced))
                            .foregroundStyle(AppColor.gold)
                        Text(HomeConstants.Streak.dayStreakLabel)
                            .font(.appCaption)
                            .foregroundStyle(AppColor.textHint)
                    }
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 6) {
                statRow(icon: HomeConstants.Stats.sessionsIcon, color: AppColor.brand, title: HomeConstants.Stats.sessionsTitle)
                statRow(icon: HomeConstants.Stats.setsIcon, color: AppColor.green, title: HomeConstants.Stats.setsTitle)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func statRow(icon: String, color: Color, title: String) -> some View {
        AppCard(radius: AppRadius.sm, padding: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 13)).foregroundStyle(color)
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                Spacer(minLength: 0)
            }
        }
    }

    private func activeProgramCard(program: Program, progress: UserProgramProgress) -> some View {
        let accent = program.difficulty.pillColor
        let totalDays = max(program.durationWeeks * program.workoutsPerWeek, 1)
        let totalWeeks = max(program.durationWeeks, 1)
        return GradientCard(colors: [accent.opacity(0.3), accent.opacity(0.08)], accent: accent, radius: 22, padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        AccentPill(program.difficulty.title, color: accent)
                        Text(program.name).font(.appH3).foregroundStyle(.white)
                    }
                    Spacer()
                    RingProgress(
                        progress: Double(progress.adherencePercent) / 100,
                        color: accent,
                        label: "\(progress.adherencePercent)%"
                    )
                }
                HStack(spacing: 12) {
                    metricChip(HomeConstants.Program.weekLabel, "\(progress.currentWeek)/\(totalWeeks)")
                    metricChip(HomeConstants.Program.dayLabel, "\(progress.currentDay)/\(totalDays)")
                }
                PrimaryButton(HomeConstants.Program.continueButtonTitle, systemImage: HomeConstants.Program.continueButtonIcon, color: accent)
            }
        }
    }

    private func metricChip(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.4))
            Text(value)
                .font(.system(size: 16, weight: .black, design: .monospaced))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func skillFocusCard(_ skill: Skill) -> some View {
        let accent = skill.family.accent
        let colors = skill.family.colors
        return AppCard(padding: 14) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(accent.opacity(0.2), lineWidth: 1)
                    Image(systemName: HomeConstants.SkillFocus.icon)
                        .foregroundStyle(accent)
                        .font(.system(size: 22))
                }
                .frame(width: 54, height: 54)

                VStack(alignment: .leading, spacing: 6) {
                    Text(skill.name)
                        .font(.appBodyLarge)
                        .foregroundStyle(AppColor.textPrimary)
                    HStack(spacing: 8) {
                        Text(HomeConstants.SkillFocus.lastLabel).font(.appCaption).foregroundStyle(AppColor.textHint)
                        Text(HomeConstants.SkillFocus.emptyValue)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(accent)
                        Text(HomeConstants.SkillFocus.separator).font(.appCaption).foregroundStyle(AppColor.textHint)
                        Text(HomeConstants.SkillFocus.targetLabel).font(.appCaption).foregroundStyle(AppColor.textHint)
                        Text(skill.targetDisplay ?? HomeConstants.SkillFocus.emptyValue)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(AppColor.textPrimary)
                    }
                    AppProgressBar(progress: 0, color: accent, height: 6)
                        .padding(.top, 2)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(accent.opacity(0.12))
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(accent.opacity(0.25), lineWidth: 1)
                    Image(systemName: HomeConstants.SkillFocus.playIcon)
                        .foregroundStyle(accent)
                        .font(.system(size: 14))
                }
                .frame(width: 40, height: 40)
            }
        }
    }

    private func recentSessionTile(_ session: WorkoutSession) -> some View {
        let workoutName = session.workout.name
        let isSkill = session.workout.category == .skill
        let accent: Color = isSkill ? AppColor.purple : AppColor.brand
        return AppCard(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(accent.opacity(0.18))
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(accent.opacity(0.3), lineWidth: 1)
                    Text(isSkill ? HomeConstants.RecentActivity.skillEmoji : HomeConstants.RecentActivity.workoutEmoji)
                        .font(.system(size: 18))
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(workoutName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                    Text(sessionMetaLabel(session))
                        .font(.appCaption)
                        .foregroundStyle(AppColor.textHint)
                }
                Spacer()
                Image(systemName: HomeConstants.RecentActivity.chevronIcon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textHint)
            }
        }
    }

    private func sessionMetaLabel(_ session: WorkoutSession) -> String {
        viewModel.sessionMetaLabel(session)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(PreviewModelContainer.shared)
}
