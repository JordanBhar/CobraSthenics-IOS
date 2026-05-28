import SwiftUI

public struct ExerciseDetailView: View {
    public let exercise: Exercise
    public let exerciseRepository: any ExerciseRepository

    @State private var selectedTab: DetailTab = .instructions
    @State private var prevExercise: Exercise?
    @State private var nextExercise: Exercise?

    public init(exercise: Exercise, exerciseRepository: any ExerciseRepository) {
        self.exercise = exercise
        self.exerciseRepository = exerciseRepository
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: AppSpacing.md) {
                    hero
                    statRow
                    ExerciseVideoSection(accent: exercise.accent, exerciseName: exercise.name, isTimed: exercise.defaultSetType == .timed)
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
        .task {
            if let prevID = exercise.progression.previousID {
                prevExercise = try? await exerciseRepository.getExercise(id: prevID)
            }
            if let nextID = exercise.progression.nextID {
                nextExercise = try? await exerciseRepository.getExercise(id: nextID)
            }
        }
        .navigationTitle(LibraryConstants.Detail.navigationTitle)
        .appNavigationBarTitleDisplayModeInline()
    }

    private var hero: some View {
        GradientCard(
            colors: [exercise.accent.opacity(0.25), exercise.accent.opacity(0.08)],
            accent: exercise.accent,
            radius: AppRadius.lg,
            padding: 18
        ) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(exercise.accent.opacity(0.18))
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(exercise.accent.opacity(0.35), lineWidth: 1)
                    Image(systemName: exercise.defaultSetType == .timed ? "timer" : "dumbbell.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(exercise.accent)
                }
                .frame(width: 64, height: 64)

                VStack(alignment: .leading, spacing: 6) {
                    AccentPill(exercise.difficulty.title, color: AppColor.difficulty(exercise.difficulty))
                    Text(exercise.name)
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(.white)
                    Text("\(exercise.equipment.replacingOccurrences(of: "_", with: " ").capitalized) · \(exercise.setTypeLabel)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private var statRow: some View {
        HStack(spacing: AppSpacing.xs) {
            statCard(LibraryConstants.Detail.targetLabel, value: targetText, color: AppColor.textPrimary)
            statCard(prLabel, value: prText, color: exercise.accent)
            statCard("Sets", value: "3", color: AppColor.textPrimary)
        }
    }

    private var targetText: String {
        switch exercise.defaultSetType {
        case .timed: return "3 × hold"
        case .amrap: return "3 × max"
        default: return "3 × 8–12"
        }
    }

    private var prLabel: String {
        switch exercise.defaultSetType {
        case .timed: return "Best Hold"
        default: return "Best Reps"
        }
    }

    private var prText: String {
        guard let pr = exercise.personalRecord else { return "—" }
        return pr.primaryDisplay
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
        if prevExercise != nil || nextExercise != nil {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("PROGRESSION CHAIN")
                    .font(.appLabel)
                    .tracking(0.8)
                    .foregroundStyle(AppColor.textSecondary)
                AppCard(padding: 14) {
                    HStack(spacing: 8) {
                        chainTile(prevExercise, label: "Easier", placeholder: "Start here")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(exercise.accent)
                        chainTile(exercise, label: "Current", current: true)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(exercise.accent)
                        chainTile(nextExercise, label: "Harder", placeholder: "Mastered")
                    }
                }
            }
        }
    }

    private func chainTile(_ exercise: Exercise?, label: String, current: Bool = false, placeholder: String = "") -> some View {
        Group {
            if let exercise {
                VStack(spacing: 4) {
                    Text(label.uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .tracking(0.8)
                        .foregroundStyle(current ? self.exercise.accent : AppColor.textSecondary)
                    Text(exercise.name)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(current ? self.exercise.accent.opacity(0.1) : AppColor.elevated)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(current ? self.exercise.accent.opacity(0.35) : AppColor.border, lineWidth: 1)
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
            ForEach(DetailTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(AppAnimation.quick) { selectedTab = tab }
                } label: {
                    Text(tab.title)
                        .font(.system(size: 11, weight: selectedTab == tab ? .bold : .medium))
                        .tracking(0.6)
                        .foregroundStyle(selectedTab == tab ? AppColor.textPrimary : AppColor.textHint)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(selectedTab == tab ? AppColor.elevated2 : Color.clear)
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
        switch selectedTab {
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
                                .fill(exercise.accent.opacity(0.18))
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .stroke(exercise.accent.opacity(0.35), lineWidth: 1)
                            Text(String(format: "%02d", index + 1))
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundStyle(exercise.accent)
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
            cuesCard("Coaching Cues", items: exercise.tips, icon: "checkmark", color: AppColor.green)
            cuesCard("Common Mistakes", items: exercise.commonMistakes, icon: "xmark", color: AppColor.red)
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
            muscleSection("Primary Muscles", items: exercise.primaryMuscles, color: exercise.accent)
            muscleSection("Secondary Muscles", items: exercise.secondaryMuscles, color: AppColor.textSecondary, outline: true)
            AppCard(background: exercise.accent.opacity(0.08), border: exercise.accent.opacity(0.25)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("EXERCISE TYPE")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(exercise.accent)
                    Text(exerciseTypeDescription)
                        .font(.system(size: 13))
                        .foregroundStyle(AppColor.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var exerciseTypeDescription: String {
        switch exercise.defaultSetType {
        case .timed: return "Static isometric hold — sustained position under tension."
        case .amrap: return "AMRAP — as many reps as possible to fatigue."
        default: return "Rep-based set — counted through full range of motion."
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

    private var stickyCTAs: some View {
        HStack(spacing: AppSpacing.xs) {
            PrimaryButton("Add to Workout", systemImage: "plus", color: exercise.accent)
            OutlineButton("Log Set", systemImage: "checkmark", color: exercise.accent)
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

private enum DetailTab: CaseIterable, Hashable {
    case instructions, cuesMistakes, muscles
    var title: String {
        switch self {
        case .instructions: return "Instructions"
        case .cuesMistakes: return "Cues & Mistakes"
        case .muscles: return "Muscles"
        }
    }
}

struct FlowLayout: View {
    let items: [String]
    let color: Color
    let outline: Bool

    init(items: [String], color: Color, outline: Bool = false) {
        self.items = items
        self.color = color
        self.outline = outline
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.5)
                    .foregroundStyle(outline ? AppColor.textSecondary : color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(outline ? Color.white.opacity(0.06) : color.opacity(0.18))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outline ? AppColor.border : color.opacity(0.3), lineWidth: 1))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            exercise: SampleData.exercises[0],
            exerciseRepository: SampleExerciseRepository()
        )
    }
    .environment(AppEnvironment.preview)
}
