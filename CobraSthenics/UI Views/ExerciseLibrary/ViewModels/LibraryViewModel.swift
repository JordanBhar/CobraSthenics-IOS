import Foundation

@Observable
@MainActor
final class LibraryViewModel {

    static let visibleCategories: [ExerciseCategory] =
        ExerciseCategory.allCases.filter { $0 != .unknown }

    var searchText: String = ""

    func filteredCategories() -> [ExerciseCategory] {
        guard !searchText.isEmpty else { return Self.visibleCategories }
        return Self.visibleCategories.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.tag.localizedCaseInsensitiveContains(searchText)
        }
    }

    func count(of category: ExerciseCategory, in exercises: [Exercise]) -> Int {
        exercises.lazy.filter { $0.category == category }.count
    }
}
