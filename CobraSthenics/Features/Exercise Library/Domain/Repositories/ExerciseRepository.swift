import Foundation

public protocol ExerciseRepository {
    func getExerciseCategories() async throws -> [ExerciseCategory]
    func getExercises(categoryID: String) async throws -> [Exercise]
    func getExercise(id: String) async throws -> Exercise?
}
