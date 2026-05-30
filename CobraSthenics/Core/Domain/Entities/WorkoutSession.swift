//
//  WorkoutSession.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-29.
//

import Foundation
import SwiftData

@Model
final class WorkoutSession {

    var id: UUID

    @Relationship(deleteRule: .nullify)
    var user: User?

    /// Template workout performed
    var workout: Workout

    /// When user started
    var startedAt: Date

    /// When user finished
    var completedAt: Date?

    /// Session notes
    var notes: String?

    /// Whether workout was completed
    var isCompleted: Bool

    /// Exercises performed during this session
    @Relationship(deleteRule: .cascade)
    var completedExercises: [WorkoutSessionExercise]

    init(
        id: UUID = UUID(),
        user: User? = nil,
        workout: Workout,
        startedAt: Date = .now,
        completedAt: Date? = nil,
        notes: String? = nil,
        isCompleted: Bool = false,
        completedExercises: [WorkoutSessionExercise] = []
    ) {
        self.id = id
        self.user = user
        self.workout = workout
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.notes = notes
        self.isCompleted = isCompleted
        self.completedExercises = completedExercises
    }
}
