import Foundation

@Observable
@MainActor
final class CategoryViewModel {

    var searchText: String = ""
    var difficulty: DifficultyFilter = .all

    func categoryExercises(from exercises: [Exercise], category: ExerciseCategory) -> [Exercise] {
        exercises.filter { $0.category == category }
    }

    func filteredExercises(from exercises: [Exercise], category: ExerciseCategory) -> [Exercise] {
        categoryExercises(from: exercises, category: category).filter { exercise in
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

    func exerciseIcon(for exercise: Exercise) -> String {
        exercise.mechanics == .staticHold ? LibraryConstants.ExerciseIcon.timed : LibraryConstants.ExerciseIcon.reps
    }
}
