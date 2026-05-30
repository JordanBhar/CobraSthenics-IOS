//
//  WorkoutSessionExercise.swift
//  CobraSthenics
//

import Foundation
import SwiftData

/// A single exercise as actually performed inside a `WorkoutSession`.
/// Distinct from `WorkoutExercise` (which is the template) — this records
/// what the user actually did.
@Model
final class WorkoutSessionExercise {

    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .nullify, inverse: \WorkoutSession.completedExercises)
    var session: WorkoutSession?

    @Relationship(deleteRule: .nullify)
    var exercise: Exercise?

    /// Order this exercise appeared in within the session.
    var orderIndex: Int

    /// Number of sets actually completed.
    var setsCompleted: Int

    /// Reps achieved (for rep-based sets).
    var reps: Int?

    /// Seconds held (for static / timed sets).
    var holdSeconds: Double?

    /// Added weight, if any.
    var weightKg: Double?

    var notes: String?

    var completedAt: Date

    init(
        id: UUID = UUID(),
        session: WorkoutSession? = nil,
        exercise: Exercise? = nil,
        orderIndex: Int = 0,
        setsCompleted: Int = 0,
        reps: Int? = nil,
        holdSeconds: Double? = nil,
        weightKg: Double? = nil,
        notes: String? = nil,
        completedAt: Date = .now
    ) {
        self.id = id
        self.session = session
        self.exercise = exercise
        self.orderIndex = orderIndex
        self.setsCompleted = setsCompleted
        self.reps = reps
        self.holdSeconds = holdSeconds
        self.weightKg = weightKg
        self.notes = notes
        self.completedAt = completedAt
    }
}
