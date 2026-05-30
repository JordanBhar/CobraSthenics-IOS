//
//  PersonalRecord.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-29.
//

import Foundation
import SwiftData

@Model
final class PersonalRecord {

    var id: UUID

    /// Exercise this PR belongs to
    var exercise: Exercise

    /// Entry that created this PR
    var sourceProgressEntry: ProgressEntry?

    var bestReps: Int?

    var bestHoldSeconds: Double?

    var bestWeightKg: Double?

    var updatedAt: Date

    init(
        id: UUID = UUID(),
        exercise: Exercise,
        sourceProgressEntry: ProgressEntry? = nil,
        bestReps: Int? = nil,
        bestHoldSeconds: Double? = nil,
        bestWeightKg: Double? = nil,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.exercise = exercise
        self.sourceProgressEntry = sourceProgressEntry
        self.bestReps = bestReps
        self.bestHoldSeconds = bestHoldSeconds
        self.bestWeightKg = bestWeightKg
        self.updatedAt = updatedAt
    }
}
