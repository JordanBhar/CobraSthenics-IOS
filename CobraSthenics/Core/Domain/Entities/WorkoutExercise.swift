import Foundation
import SwiftData

@Model
final class WorkoutExercise {

    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .nullify)
    var exercise: Exercise?
    
    var setType: SetType

    var reps: Int?
    var sets: Int
    var targetSeconds: Double?
    
    var restSeconds: Int
    var orderIndex: Int

    var notes: String?

    init(
        id: UUID = UUID(),
        exercise: Exercise? = nil,
        setType: SetType,
        sets: Int,
        reps: Int? = nil,
        targetSeconds: Double? = nil,
        restSeconds: Int = 60,
        orderIndex: Int,
        notes: String? = nil
    ) {
        self.id = id
        self.exercise = exercise
        self.setType = setType
        self.sets = sets
        self.reps = reps
        self.targetSeconds = targetSeconds
        self.restSeconds = restSeconds
        self.orderIndex = orderIndex
        self.notes = notes
    }
}
