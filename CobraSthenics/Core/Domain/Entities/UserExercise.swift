//
//  UserExercise.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-29.
//
import Foundation
import SwiftData

/// Per-user mutable state for a catalog `Exercise`. Holds data that does not
/// belong on either `Exercise` (immutable catalog) or `ProgressEntry`
/// (append-only history): unlock status, skill-tier status, mastery progress,
/// last-performed timestamp, and (eventually) favorites/bookmarks.
///
/// Currently unwired — registered in the model container as scaffolding for
/// upcoming user-progression features. Do not delete.
@Model
final class UserExercise {

    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .nullify)
    var user: User?

    @Relationship(deleteRule: .nullify)
    var exercise: Exercise?
    
    var skillStatus: SkillStatus

    var isUnlocked: Bool

    var masteryPercent: Double

    var lastPerformedAt: Date?

    init(
        id: UUID = UUID(),
        user: User? = nil,
        exercise: Exercise? = nil,
        isUnlocked: Bool = false,
        masteryPercent: Double = 0,
        lastPerformedAt: Date? = nil,
        skillStatus: SkillStatus
    ) {
        self.id = id
        self.user = user
        self.exercise = exercise
        self.isUnlocked = isUnlocked
        self.masteryPercent = masteryPercent
        self.lastPerformedAt = lastPerformedAt
        self.skillStatus = skillStatus
    }
}

