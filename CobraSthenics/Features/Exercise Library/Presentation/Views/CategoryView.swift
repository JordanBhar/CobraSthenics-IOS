import SwiftUI

public struct CategoryView: View {
    public let category: ExerciseCategory
    public let exerciseRepository: any ExerciseRepository

    @State private var exercises: [Exercise] = []
    @State private var searchText = ""
    @State private var difficulty: DifficultyFilter = .all

    public init(category: ExerciseCategory, exerciseRepository: any ExerciseRepository) {
        self.category = category
        self.exerciseRepository = exerciseRepository
    }

    private var filteredExercises: [Exercise] {
        exercises.filter { exercise in
            let matchesSearch = searchText.isEmpty || exercise.name.localizedCaseInsensitiveContains(searchText)
            let matchesDifficulty: Bool = {
                switch difficulty {
                case .all: return true
                case .level(let value): return exercise.difficulty == value
                }
            }()
            return matchesSearch && matchesDifficulty
        }
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    hero
                    SearchField(text: $searchText, placeholder: "Search \(exercises.count) exercises…")
                    FilterChips(
                        options: DifficultyFilter.allOptions,
                        selected: difficulty,
                        label: { $0.title },
                        onSelect: { difficulty = $0 }
                    )
                    Text("\(filteredExercises.count) \(filteredExercises.count == 1 ? "exercise" : "exercises")")
                        .font(.appLabel)
                        .tracking(0.8)
                        .foregroundStyle(AppColor.textSecondary)
                    if filteredExercises.isEmpty {
                        AppCard {
                            Text(searchText.isEmpty
                                 ? "No exercises in this difficulty.\nTry a different filter."
                                 : "No results for \"\(searchText)\"")
                                .font(.appBody)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(AppColor.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.lg)
                        }
                    } else {
                        VStack(spacing: AppSpacing.xs) {
                            ForEach(filteredExercises) { exercise in
                                NavigationLink {
                                    ExerciseDetailView(exercise: exercise, exerciseRepository: exerciseRepository)
                                } label: {
                                    exerciseTile(exercise)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppLayout.bottomBarClearance)
            }
        }
        .task {
            exercises = (try? await exerciseRepository.getExercises(categoryID: category.id)) ?? []
        }
        .navigationTitle(category.name)
        .appNavigationBarTitleDisplayModeInline()
    }

    private var hero: some View {
        GradientCard(colors: category.colors, accent: category.accent, radius: AppRadius.lg, padding: 18) {
            VStack(alignment: .leading, spacing: 10) {
                AccentPill(category.tag, color: category.accent)
                Text(category.name)
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)
                HStack(spacing: 16) {
                    catStat("Exercises", value: exercises.count, accent: category.accent)
                    catStat("Logged", value: min(exercises.count, 4), accent: AppColor.green)
                    catStat("PRs", value: min(exercises.count, 3), accent: AppColor.gold)
                }
                .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func catStat(_ label: String, value: Int, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value)")
                .font(.system(size: 20, weight: .black, design: .monospaced))
                .foregroundStyle(accent)
            Text(label.uppercased())
                .font(.system(size: 9, weight: .bold))
                .tracking(1)
                .foregroundStyle(.white.opacity(0.5))
        }
    }

    private func exerciseTile(_ exercise: Exercise) -> some View {
        AppCard(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(LinearGradient(colors: [exercise.accent.opacity(0.18), exercise.accent.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(exercise.accent.opacity(0.3), lineWidth: 1)
                    Image(systemName: exerciseIcon(for: exercise))
                        .font(.system(size: 20))
                        .foregroundStyle(exercise.accent)
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 6) {
                    Text(exercise.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                        .lineLimit(1)
                    HStack(spacing: 8) {
                        AccentPill(exercise.difficulty.title, color: AppColor.difficulty(exercise.difficulty))
                        Text(exercise.equipment.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(AppColor.textSecondary)
                    }
                    HStack(spacing: 10) {
                        ForEach(exercise.primaryMuscles.prefix(2), id: \.self) { muscle in
                            Text(muscle)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(exercise.accent)
                        }
                        if let first = exercise.secondaryMuscles.first {
                            Text("+ \(first)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(AppColor.textHint)
                        }
                    }
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textHint)
            }
        }
    }

    private func exerciseIcon(for exercise: Exercise) -> String {
        switch exercise.defaultSetType {
        case .timed: return "timer"
        case .amrap: return "flame"
        default: return "dumbbell.fill"
        }
    }
}

public enum DifficultyFilter: Hashable {
    case all
    case level(Difficulty)

    public var title: String {
        switch self {
        case .all: return "All"
        case .level(let d): return d.title
        }
    }

    public static let allOptions: [DifficultyFilter] = [
        .all, .level(.beginner), .level(.intermediate), .level(.advanced), .level(.elite)
    ]
}

#Preview {
    NavigationStack {
        CategoryView(
            category: SampleData.categories[0],
            exerciseRepository: SampleExerciseRepository()
        )
    }
    .environment(AppEnvironment.preview)
}
