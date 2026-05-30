import SwiftUI
import SwiftData

public struct WorkoutView: View {

    @Query(sort: \Workout.name) private var workouts: [Workout]
    @Query private var activeProgress: [UserProgramProgress]

    @State private var viewModel = WorkoutViewModel()

    public init() {
        let predicate = #Predicate<UserProgramProgress> { $0.isActive == true }
        _activeProgress = Query(filter: predicate)
    }

    private var activeProgram: UserProgramProgress? { activeProgress.first }
    private var filteredWorkouts: [Workout] { viewModel.filteredWorkouts(from: workouts) }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    AppHeader(eyebrow: WorkoutConstants.Header.eyebrow, title: WorkoutConstants.Header.title)
                    quickActions
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        SectionHeader(WorkoutConstants.Program.sectionTitle, actionTitle: WorkoutConstants.Program.sectionAction)
                        if let active = activeProgram, let program = active.program {
                            programHero(program: program, progress: active)
                        } else {
                            noProgram
                        }
                    }
                    FilterChips(
                        options: WorkoutCategory.filterOptions,
                        selected: viewModel.selectedCategory,
                        label: { $0.title },
                        onSelect: { viewModel.selectedCategory = $0 }
                    )
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(filteredWorkouts) { workout in
                            workoutTile(workout)
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

    private var quickActions: some View {
        HStack(spacing: AppSpacing.xs) {
            quickAction(WorkoutConstants.QuickActions.quickStart, icon: WorkoutConstants.QuickActions.quickStartIcon, accent: AppColor.brand, filled: true)
            quickAction(WorkoutConstants.QuickActions.customBuild, icon: WorkoutConstants.QuickActions.customBuildIcon, accent: AppColor.textSecondary)
            quickAction(WorkoutConstants.QuickActions.calendar, icon: WorkoutConstants.QuickActions.calendarIcon, accent: AppColor.textSecondary)
        }
    }

    private func quickAction(_ title: String, icon: String, accent: Color, filled: Bool = false) -> some View {
        Button {} label: {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 16, weight: .bold))
                Text(title.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(0.8)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(accent)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(filled ? accent.opacity(0.14) : AppColor.elevated)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(filled ? accent.opacity(0.32) : AppColor.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func programHero(program: Program, progress: UserProgramProgress) -> some View {
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
                    RingProgress(progress: Double(progress.adherencePercent) / 100, color: accent, label: "\(progress.adherencePercent)%")
                }
                HStack(spacing: 12) {
                    chip(WorkoutConstants.Program.weekLabel, "\(progress.currentWeek)/\(totalWeeks)")
                    chip(WorkoutConstants.Program.dayLabel, "\(progress.currentDay)/\(totalDays)")
                }
                PrimaryButton(WorkoutConstants.Program.continueButtonTitle, systemImage: WorkoutConstants.Program.continueButtonIcon, color: accent)
            }
        }
    }

    private var noProgram: some View {
        AppCard {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: WorkoutConstants.EmptyProgram.icon).font(.largeTitle).foregroundStyle(AppColor.textHint)
                Text(WorkoutConstants.EmptyProgram.title).font(.appBodyLarge).foregroundStyle(AppColor.textSecondary)
                PrimaryButton(WorkoutConstants.EmptyProgram.browseButtonTitle)
            }
        }
    }

    private func chip(_ label: String, _ value: String) -> some View {
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

    private func workoutTile(_ workout: Workout) -> some View {
        let accent = workout.category.accent
        return AppCard(padding: 14) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(LinearGradient(colors: workout.category.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(accent.opacity(0.25), lineWidth: 1)
                    Image(systemName: WorkoutConstants.Workouts.icon)
                        .font(.system(size: 22))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 6) {
                    Text(workout.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColor.textPrimary)
                    Text("\(workout.exercises.count) \(WorkoutConstants.Workouts.exercisesSuffix) · \(viewModel.durationLabel(for: workout))")
                        .font(.appCaption)
                        .foregroundStyle(AppColor.textHint)
                    HStack(spacing: 8) {
                        ForEach(viewModel.primaryMuscleNames(for: workout), id: \.self) { muscle in
                            Text(muscle)
                                .font(.system(size: 10, weight: .semibold))
                                .tracking(0.4)
                                .foregroundStyle(accent)
                        }
                    }
                }
                Spacer(minLength: 0)
                difficultyPill(workout.difficulty)
            }
        }
    }

    private func difficultyPill(_ difficulty: Difficulty) -> some View {
        let color = difficulty.pillColor
        return Text(difficulty.title.uppercased())
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .tracking(0.8)
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.14))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(color.opacity(0.3), lineWidth: 1))
    }
}

#Preview {
    NavigationStack {
        WorkoutView()
    }
    .modelContainer(PreviewModelContainer.shared)
}
