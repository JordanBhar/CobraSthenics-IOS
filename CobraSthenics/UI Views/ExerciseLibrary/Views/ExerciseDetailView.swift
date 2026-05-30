import SwiftUI
import SwiftData

public struct ExerciseDetailView: View {

    let exercise: Exercise

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ExerciseDetailViewModel()

    init(exercise: Exercise) {
        self.exercise = exercise
    }

    private var isTimed: Bool { exercise.mechanics == .staticHold }
    private var accent: Color { exercise.category.accent }

    public var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    hero
                    statRow
                    ExerciseVideoSection(accent: accent, exerciseName: exercise.name, isTimed: isTimed)
                    progressionChain
                    tabSelector
                    tabContent
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, 130)
            }
            stickyCTAs
        }
        .task { viewModel.loadRelations(for: exercise, in: modelContext) }
        .navigationTitle(LibraryConstants.Detail.navigationTitle)
        .appNavigationBarTitleDisplayModeInline()
    }

    private var hero: some View {
        GradientCard(
            colors: [accent.opacity(0.25), accent.opacity(0.08)],
            accent: accent,
            radius: AppRadius.lg,
            padding: 18
        ) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(accent.opacity(0.18))
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(accent.opacity(0.35), lineWidth: 1)
                    Image(systemName: isTimed ? LibraryConstants.ExerciseIcon.timed : LibraryConstants.ExerciseIcon.reps)
                        .font(.system(size: 28))
                        .foregroundStyle(accent)
                }
                .frame(width: 64, height: 64)

                VStack(alignment: .leading, spacing: 6) {
                    AccentPill(exercise.difficulty.title, color: AppColor.difficulty(exercise.difficulty))
                    Text(exercise.name)
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(.white)
                    Text("\(exercise.equipment.displayName) · \(setTypeLabel)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private var setTypeLabel: String { viewModel.setTypeLabel(isTimed: isTimed) }

    private var statRow: some View {
        HStack(spacing: AppSpacing.xs) {
            statCard(LibraryConstants.Detail.targetLabel, value: viewModel.targetText(isTimed: isTimed), color: AppColor.textPrimary)
            statCard(viewModel.prLabel(isTimed: isTimed), value: viewModel.prText(isTimed: isTimed), color: accent)
            statCard(LibraryConstants.Detail.setsLabel, value: "3", color: AppColor.textPrimary)
        }
    }

    private func statCard(_ label: String, value: String, color: Color) -> some View {
        AppCard(padding: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(AppColor.textHint)
                Text(value)
                    .font(.system(size: 17, weight: .black, design: .monospaced))
                    .foregroundStyle(color)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var progressionChain: some View {
        if viewModel.previousExercise != nil || viewModel.nextExercise != nil {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(LibraryConstants.Detail.progressionChainTitle)
                    .font(.appLabel)
                    .tracking(0.8)
                    .foregroundStyle(AppColor.textSecondary)
                AppCard(padding: 14) {
                    HStack(spacing: 8) {
                        chainTile(viewModel.previousExercise, label: LibraryConstants.Detail.chainEasier, placeholder: LibraryConstants.Detail.chainPlaceholderStart)
                        Image(systemName: LibraryConstants.Category.chevronIcon)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(accent)
                        chainTile(exercise, label: LibraryConstants.Detail.chainCurrent, current: true)
                        Image(systemName: LibraryConstants.Category.chevronIcon)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(accent)
                        chainTile(viewModel.nextExercise, label: LibraryConstants.Detail.chainHarder, placeholder: LibraryConstants.Detail.chainPlaceholderMastered)
                    }
                }
            }
        }
    }

    private func chainTile(_ tileExercise: Exercise?, label: String, current: Bool = false, placeholder: String = "") -> some View {
        Group {
            if let tileExercise {
                VStack(spacing: 4) {
                    Text(label.uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .tracking(0.8)
                        .foregroundStyle(current ? accent : AppColor.textSecondary)
                    Text(tileExercise.name)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(current ? accent.opacity(0.1) : AppColor.elevated)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(current ? accent.opacity(0.35) : AppColor.border, lineWidth: 1)
                )
            } else {
                VStack(spacing: 4) {
                    Text(label.uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .tracking(0.8)
                        .foregroundStyle(AppColor.textHint)
                    Text(placeholder)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(AppColor.textHint)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(AppColor.border, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                )
            }
        }
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(ExerciseDetailViewModel.Tab.allCases, id: \.self) { tab in
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
        case .cuesMistakes: cuesAndMistakes
        case .muscles: musclesSection
        }
    }

    private var instructionsList: some View {
        VStack(spacing: AppSpacing.xs) {
            ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, step in
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

    private var cuesAndMistakes: some View {
        VStack(spacing: AppSpacing.sm) {
            cuesCard(LibraryConstants.Detail.coachingCuesTitle, items: exercise.tips, icon: LibraryConstants.Detail.coachingCuesIcon, color: AppColor.green)
            cuesCard(LibraryConstants.Detail.commonMistakesTitle, items: exercise.commonMistakes, icon: LibraryConstants.Detail.commonMistakesIcon, color: AppColor.red)
        }
    }

    private func cuesCard(_ label: String, items: [String], icon: String, color: Color) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(label.uppercased())
                    .font(.appLabel)
                    .tracking(1)
                    .foregroundStyle(color)
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: icon)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(color)
                            .padding(.top, 2)
                        Text(item)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AppColor.textPrimary)
                    }
                }
            }
        }
    }

    private var musclesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            muscleSection(LibraryConstants.Detail.primaryMusclesTitle, items: exercise.primaryMuscleGroups.map(\.displayName), color: accent)
            muscleSection(LibraryConstants.Detail.secondaryMusclesTitle, items: exercise.secondaryMuscleGroups.map(\.displayName), color: AppColor.textSecondary, outline: true)
            AppCard(background: accent.opacity(0.08), border: accent.opacity(0.25)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(LibraryConstants.Detail.exerciseTypeLabel)
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(accent)
                    Text(exerciseTypeDescription)
                        .font(.system(size: 13))
                        .foregroundStyle(AppColor.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var exerciseTypeDescription: String { viewModel.exerciseTypeDescription(isTimed: isTimed) }

    private func muscleSection(_ title: String, items: [String], color: Color, outline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title.uppercased())
                .font(.appLabel)
                .tracking(0.8)
                .foregroundStyle(AppColor.textSecondary)
            FlowLayout(items: items, color: color, outline: outline)
        }
    }

    private var stickyCTAs: some View {
        HStack(spacing: AppSpacing.xs) {
            PrimaryButton(LibraryConstants.Detail.ctaAddToWorkout, systemImage: LibraryConstants.Detail.ctaAddIcon, color: accent)
            OutlineButton(LibraryConstants.Detail.ctaLogSet, systemImage: LibraryConstants.Detail.ctaLogIcon, color: accent)
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
        PreviewExerciseDetail()
    }
    .modelContainer(PreviewModelContainer.shared)
}

private struct PreviewExerciseDetail: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]

    var body: some View {
        if let first = exercises.first {
            ExerciseDetailView(exercise: first)
        } else {
            Text("No seeded exercises")
        }
    }
}
