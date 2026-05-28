import SwiftUI

public struct TrainView: View {
    @State private var viewModel: TrainViewModel

    public init(viewModel: TrainViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    AppHeader(eyebrow: "Cobrasthenics", title: "Train")
                    quickActions
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        SectionHeader("My Program", actionTitle: "All Programs")
                        if let program = viewModel.activeProgram {
                            programHero(program)
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
                        ForEach(viewModel.filteredWorkouts) { workout in
                            workoutTile(workout)
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

    private var quickActions: some View {
        HStack(spacing: AppSpacing.xs) {
            quickAction("Quick Start", icon: "bolt.fill", accent: AppColor.brand, filled: true)
            quickAction("Custom Build", icon: "plus", accent: AppColor.textSecondary)
            quickAction("Calendar", icon: "calendar", accent: AppColor.textSecondary)
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

    private func programHero(_ program: ActiveProgram) -> some View {
        GradientCard(colors: program.colors, accent: program.accent, radius: 22, padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        AccentPill(program.level, color: program.accent)
                        Text(program.name).font(.appH3).foregroundStyle(.white)
                    }
                    Spacer()
                    RingProgress(progress: Double(program.adherencePercent) / 100, color: program.accent, label: "\(program.adherencePercent)%")
                }
                HStack(spacing: 12) {
                    chip("Week", "\(program.currentWeek)/\(program.totalWeeks)")
                    chip("Day", "\(program.currentDay)/\(program.totalDays)")
                }
                PrimaryButton("Continue Today's Session", systemImage: "arrow.right", color: program.accent)
            }
        }
    }

    private var noProgram: some View {
        AppCard {
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: "plus.circle").font(.largeTitle).foregroundStyle(AppColor.textHint)
                Text("No active program").font(.appBodyLarge).foregroundStyle(AppColor.textSecondary)
                PrimaryButton("Browse Programs")
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
        AppCard(padding: 14) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(LinearGradient(colors: workout.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(workout.accent.opacity(0.25), lineWidth: 1)
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 6) {
                    Text(workout.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColor.textPrimary)
                    Text("\(workout.exerciseCount) exercises · \(workout.duration)")
                        .font(.appCaption)
                        .foregroundStyle(AppColor.textHint)
                    HStack(spacing: 8) {
                        ForEach(workout.muscles, id: \.self) { muscle in
                            Text(muscle)
                                .font(.system(size: 10, weight: .semibold))
                                .tracking(0.4)
                                .foregroundStyle(workout.accent)
                        }
                    }
                }
                Spacer(minLength: 0)
                difficultyPill(for: workout.level)
            }
        }
    }

    private func difficultyPill(for level: String) -> some View {
        let color = difficultyColor(level)
        return Text(level.uppercased())
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .tracking(0.8)
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.14))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(color.opacity(0.3), lineWidth: 1))
    }

    private func difficultyColor(_ level: String) -> Color {
        switch level.lowercased() {
        case "beginner": return AppColor.green
        case "intermediate": return AppColor.orange
        case "advanced": return AppColor.red
        case "elite": return AppColor.purple
        default: return AppColor.textSecondary
        }
    }
}

extension WorkoutCategory {
    static var filterOptions: [WorkoutCategory] {
        [.all, .strength, .skill, .mobility, .rings]
    }
}

#Preview {
    NavigationStack {
        TrainView(viewModel: TrainViewModel(workoutRepository: SampleWorkoutRepository()))
    }
    .environment(AppEnvironment.preview)
}
