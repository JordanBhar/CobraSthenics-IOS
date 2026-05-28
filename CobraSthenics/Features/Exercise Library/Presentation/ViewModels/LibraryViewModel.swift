import SwiftUI
import Observation

@Observable
@MainActor
public final class LibraryViewModel{
    var categories: [ExerciseCategory] = []
    var searchText = ""

    private let exerciseRepository: any ExerciseRepository

    public init(exerciseRepository: any ExerciseRepository) {
        self.exerciseRepository = exerciseRepository
    }

    var filteredCategories: [ExerciseCategory] {
        guard !searchText.isEmpty else { return categories }
        return categories.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.tag.localizedCaseInsensitiveContains(searchText)
        }
    }

    func load() async {
        guard categories.isEmpty else { return }
        categories = (try? await exerciseRepository.getExerciseCategories()) ?? []
    }
}
