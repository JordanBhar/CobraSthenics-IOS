import SwiftUI
import SwiftData

public struct CategoryView: View {

    let category: ExerciseCategory

    @Query(sort: \Exercise.name) private var allExercises: [Exercise]
    @State private var viewModel = CategoryViewModel()

    init(category: ExerciseCategory) {
        self.category = category
    }

    private var categoryExercises: [Exercise] {
        viewModel.categoryExercises(from: allExercises, category: category)
    }

    private var filteredExercises: [Exercise] {
        viewModel.filteredExercises(from: allExercises, category: category)
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    hero
                    SearchField(text: $viewModel.searchText, placeholder: String(format: LibraryConstants.Search.categoryPlaceholderFormat, categoryExercises.count))
                    FilterChips(
                        options: DifficultyFilter.allOptions,
                        selected: viewModel.difficulty,
                        label: { $0.title },
                        onSelect: { viewModel.difficulty = $0 }
                    )
                    Text("\(filteredExercises.count) \(filteredExercises.count == 1 ? LibraryConstants.Category.exerciseSingular : LibraryConstants.Category.exercisesSuffix)")
                        .font(.appLabel)
                        .tracking(0.8)
                        .foregroundStyle(AppColor.textSecondary)
                    if filteredExercises.isEmpty {
                        AppCard {
                            Text(viewModel.searchText.isEmpty
                                 ? LibraryConstants.Category.emptyFilterMessage
                                 : String(format: LibraryConstants.Category.emptySearchFormat, viewModel.searchText))
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
                                    ExerciseDetailView(exercise: exercise)
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
        .navigationTitle(category.title)
        .appNavigationBarTitleDisplayModeInline()
    }

    private var hero: some View {
        GradientCard(colors: category.colors, accent: category.accent, radius: AppRadius.lg, padding: 18) {
            VStack(alignment: .leading, spacing: 10) {
                AccentPill(category.tag, color: category.accent)
                Text(category.title)
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)
                HStack(spacing: 16) {
                    catStat(LibraryConstants.Category.exercisesLabel, value: categoryExercises.count, accent: category.accent)
                    catStat(LibraryConstants.Category.loggedLabel, value: min(categoryExercises.count, 4), accent: AppColor.green)
                    catStat(LibraryConstants.Category.prsLabel, value: min(categoryExercises.count, 3), accent: AppColor.gold)
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
                        .fill(LinearGradient(colors: [category.accent.opacity(0.18), category.accent.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(category.accent.opacity(0.3), lineWidth: 1)
                    Image(systemName: viewModel.exerciseIcon(for: exercise))
                        .font(.system(size: 20))
                        .foregroundStyle(category.accent)
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 6) {
                    Text(exercise.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                        .lineLimit(1)
                    HStack(spacing: 8) {
                        AccentPill(exercise.difficulty.title, color: AppColor.difficulty(exercise.difficulty))
                        Text(exercise.equipment.displayName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(AppColor.textSecondary)
                    }
                    HStack(spacing: 10) {
                        ForEach(Array(exercise.primaryMuscleGroups.prefix(2)), id: \.self) { muscle in
                            Text(muscle.displayName)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(category.accent)
                        }
                        if let first = exercise.secondaryMuscleGroups.first {
                            Text("+ \(first.displayName)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(AppColor.textHint)
                        }
                    }
                }
                Spacer(minLength: 0)
                Image(systemName: LibraryConstants.Category.chevronIcon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textHint)
            }
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
        CategoryView(category: .push)
    }
    .modelContainer(PreviewModelContainer.shared)
}
