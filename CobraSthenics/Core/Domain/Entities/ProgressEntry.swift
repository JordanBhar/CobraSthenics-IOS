import Foundation
import SwiftData

@Model
final class ProgressEntry {

    var id: UUID

    var exercise: Exercise

    var reps: Int?

    var holdSeconds: Double?

    var weightKg: Double?

    var notes: String?

    var recordedAt: Date

    init(
        id: UUID = UUID(),
        exercise: Exercise,
        reps: Int? = nil,
        holdSeconds: Double? = nil,
        weightKg: Double? = nil,
        notes: String? = nil,
        recordedAt: Date = .now
    ) {
        self.id = id
        self.exercise = exercise
        self.reps = reps
        self.holdSeconds = holdSeconds
        self.weightKg = weightKg
        self.notes = notes
        self.recordedAt = recordedAt
    }
}
