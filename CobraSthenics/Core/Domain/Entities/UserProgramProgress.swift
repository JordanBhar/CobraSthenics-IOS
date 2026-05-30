//
//  UserProgramProgress.swift
//  CobraSthenics
//

import Foundation
import SwiftData

/// A user's progress through a specific Program. Program is the immutable
/// template; this entity holds the mutable per-user state (current day/week,
/// adherence, start date).
@Model
final class UserProgramProgress {

    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .nullify)
    var program: Program?

    var startedAt: Date

    var currentWeek: Int
    var currentDay: Int

    /// 0...100 — share of scheduled workouts the user has completed.
    var adherencePercent: Int

    var isActive: Bool

    init(
        id: UUID = UUID(),
        program: Program?,
        startedAt: Date = .now,
        currentWeek: Int = 1,
        currentDay: Int = 1,
        adherencePercent: Int = 0,
        isActive: Bool = true
    ) {
        self.id = id
        self.program = program
        self.startedAt = startedAt
        self.currentWeek = currentWeek
        self.currentDay = currentDay
        self.adherencePercent = adherencePercent
        self.isActive = isActive
    }
}
