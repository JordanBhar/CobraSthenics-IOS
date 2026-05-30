import Foundation
import SwiftData

@Model
final class Program {

    @Attribute(.unique) var id: UUID

    var name: String
    var programDescription: String?

    var difficulty: Difficulty
    
    var durationWeeks: Int

    var workoutsPerWeek: Int

    @Relationship(deleteRule: .cascade)
    var workouts: [Workout] = []

    init(
        id: UUID = UUID(),
        name: String,
        programDescription: String? = nil,
        difficulty: Difficulty,
        durationWeeks: Int = 0,
        workoutsPerWeek: Int = 0
    ) {
        self.id = id
        self.name = name
        self.programDescription = programDescription
        self.difficulty = difficulty
        self.durationWeeks = durationWeeks
        self.workoutsPerWeek = workoutsPerWeek
    }
}
