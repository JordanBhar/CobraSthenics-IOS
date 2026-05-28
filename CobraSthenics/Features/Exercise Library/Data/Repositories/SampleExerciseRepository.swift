import Foundation

public final class SampleExerciseRepository: ExerciseRepository {
    public init() {}

    public func getExerciseCategories() async throws -> [ExerciseCategory] {
        SampleData.categories
    }

    public func getExercises(categoryID: String) async throws -> [Exercise] {
        SampleData.exercises.filter { $0.category == categoryID }
    }

    public func getExercise(id: String) async throws -> Exercise? {
        SampleData.exercises.first { $0.id == id }
    }
}
