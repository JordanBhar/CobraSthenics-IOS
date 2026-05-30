import Foundation
import SwiftData

@Model
final class Workout {

    @Attribute(.unique) var id: UUID

    var name: String
    var workoutDescription: String?

    var category: WorkoutCategory
    var difficulty: Difficulty

    var estimatedDurationMinutes: Int?

    @Relationship(deleteRule: .cascade)
    var exercises: [WorkoutExercise] = []

    init(
        id: UUID = UUID(),
        name: String,
        workoutDescription: String? = nil,
        category: WorkoutCategory = .unknown,
        difficulty: Difficulty = .unknown,
        estimatedDurationMinutes: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.workoutDescription = workoutDescription
        self.category = category
        self.difficulty = difficulty
        self.estimatedDurationMinutes = estimatedDurationMinutes
    }
}
