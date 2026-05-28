import SwiftUI

public struct HomeView: View {
    @State private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            if let _homeData = viewModel.homedata {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        greeting(user: _homeData.user)
                        dayStrip(_homeData.weekDays)
                        streakRow(streak: _homeData.streakDays)
                        if let program = _homeData.activeProgram {
                            activeProgramCard(program)
                                .padding(.top, AppSpacing.xs)
                        }
                        if let skill = _homeData.featuredSkill {
                            SectionHeader("Skill Focus", actionTitle: "All Skills")
                                .padding(.top, AppSpacing.xs)
                            skillFocusCard(skill)
                        }
                        SectionHeader("Recent Activity", actionTitle: "History")
                            .padding(.top, AppSpacing.xs)
                        VStack(spacing: AppSpacing.xs) {
                            ForEach(_homeData.recentWorkouts) { workout in
                                recentWorkoutTile(workout)
                            }
                        }
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

    private func greeting(user: UserProfileModel) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Good morning 👋")
                    .font(.appLabel)
                    .foregroundStyle(AppColor.textSecondary)
                Text(user.displayName.components(separatedBy: " ").first ?? user.displayName)
                    .font(.appH1)
                    .foregroundStyle(AppColor.textPrimary)
            }
            Spacer()
            iconButton(systemImage: "bell")
        }
    }

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
                    Text("🔥").font(.system(size: 24))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(streak)")
                            .font(.system(size: 22, weight: .black, design: .monospaced))
                            .foregroundStyle(AppColor.gold)
                        Text("Day Streak")
                            .font(.appCaption)
                            .foregroundStyle(AppColor.textHint)
                    }
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 6) {
                statRow(icon: "dumbbell.fill", color: AppColor.brand, title: "3 / 5 sessions")
                statRow(icon: "chart.bar.fill", color: AppColor.green, title: "2,840 total sets")
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

    private func activeProgramCard(_ program: ActiveProgram) -> some View {
        GradientCard(colors: program.colors, accent: program.accent, radius: 22, padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        AccentPill(program.level, color: program.accent)
                        Text(program.name).font(.appH3).foregroundStyle(.white)
                    }
                    Spacer()
                    RingProgress(
                        progress: Double(program.adherencePercent) / 100,
                        color: program.accent,
                        label: "\(program.adherencePercent)%"
                    )
                }
                HStack(spacing: 12) {
                    metricChip("Week", "\(program.currentWeek)/\(program.totalWeeks)")
                    metricChip("Day", "\(program.currentDay)/\(program.totalDays)")
                }
                PrimaryButton("Continue Today's Session", systemImage: "arrow.right", color: program.accent)
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

    private func skillFocusCard(_ skill: SkillModel) -> some View {
        AppCard(padding: 14) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(LinearGradient(colors: skill.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(skill.accent.opacity(0.2), lineWidth: 1)
                    Image(systemName: "target")
                        .foregroundStyle(skill.accent)
                        .font(.system(size: 22))
                }
                .frame(width: 54, height: 54)

                VStack(alignment: .leading, spacing: 6) {
                    Text(skill.name)
                        .font(.appBodyLarge)
                        .foregroundStyle(AppColor.textPrimary)
                    HStack(spacing: 8) {
                        Text("Last:").font(.appCaption).foregroundStyle(AppColor.textHint)
                        Text(skill.bestDisplay ?? "—")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(skill.accent)
                        Text("·").font(.appCaption).foregroundStyle(AppColor.textHint)
                        Text("Target:").font(.appCaption).foregroundStyle(AppColor.textHint)
                        Text(skill.target)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(AppColor.textPrimary)
                    }
                    AppProgressBar(progress: Double(skill.progressPercent) / 100, color: skill.accent, height: 6)
                        .padding(.top, 2)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(skill.accent.opacity(0.12))
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(skill.accent.opacity(0.25), lineWidth: 1)
                    Image(systemName: "play.fill")
                        .foregroundStyle(skill.accent)
                        .font(.system(size: 14))
                }
                .frame(width: 40, height: 40)
            }
        }
    }

    private func recentWorkoutTile(_ workout: RecentWorkout) -> some View {
        AppCard(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .fill(workout.accent.opacity(0.18))
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(workout.accent.opacity(0.3), lineWidth: 1)
                    Text(workout.isSkillSession ? "🎯" : "💪")
                        .font(.system(size: 18))
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                    Text("\(workout.dateLabel) · \(workout.setCount) sets · \(workout.duration)")
                        .font(.appCaption)
                        .foregroundStyle(AppColor.textHint)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textHint)
            }
        }
    }
}

#Preview {
    NavigationStack{
        HomeView(viewModel: HomeViewModel(homeRepository: SampleHomeRepository()))
    }
    .environment(AppEnvironment.preview)
}
