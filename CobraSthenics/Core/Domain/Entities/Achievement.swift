//
//  Achievement.swift
//  CobraSthenics
//

import Foundation
import SwiftData

@Model
final class Achievement {

    @Attribute(.unique) var id: UUID

    var name: String
    var achievementDescription: String?

    /// SF Symbol or emoji used to render the badge.
    var iconSymbol: String

    var earnedAt: Date?

    var isEarned: Bool {
        earnedAt != nil
    }

    init(
        id: UUID = UUID(),
        name: String,
        achievementDescription: String? = nil,
        iconSymbol: String,
        earnedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.achievementDescription = achievementDescription
        self.iconSymbol = iconSymbol
        self.earnedAt = earnedAt
    }
}
