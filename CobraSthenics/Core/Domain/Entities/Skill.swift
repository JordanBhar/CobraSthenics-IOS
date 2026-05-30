//
//  Skill.swift
//  CobraSthenics
//

import Foundation
import SwiftData

@Model
final class Skill {

    // MARK: - Identity

    @Attribute(.unique) var id: UUID

    // MARK: - Basic Information

    var name: String
    var skillDescription: String?

    // MARK: - Classification

    var family: SkillFamily

    var difficulty: Difficulty

    var primaryMuscleGroups: [MuscleGroup]
    var secondaryMuscleGroups: [MuscleGroup]

    var isStaticHold: Bool

    // MARK: - Tier Progression

    var tierIndex: Int
    var totalTiers: Int
    var currentTierName: String
    var nextTierName: String?

    /// Performance target for the next tier (e.g. seconds of hold, rep count).
    /// Stored as a free-form string so timed and rep-based skills share the model.
    var targetDisplay: String?

    // MARK: - Instructions

    var instructions: [String]

    // MARK: - Media

    var thumbnailURL: String?
    var videoURL: String?

    init(
        id: UUID = UUID(),
        name: String,
        skillDescription: String? = nil,
        family: SkillFamily,
        difficulty: Difficulty = .unknown,
        primaryMuscleGroups: [MuscleGroup] = [],
        secondaryMuscleGroups: [MuscleGroup] = [],
        isStaticHold: Bool = false,
        tierIndex: Int = 0,
        totalTiers: Int = 1,
        currentTierName: String,
        nextTierName: String? = nil,
        targetDisplay: String? = nil,
        instructions: [String] = [],
        thumbnailURL: String? = nil,
        videoURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.skillDescription = skillDescription
        self.family = family
        self.difficulty = difficulty
        self.primaryMuscleGroups = primaryMuscleGroups
        self.secondaryMuscleGroups = secondaryMuscleGroups
        self.isStaticHold = isStaticHold
        self.tierIndex = tierIndex
        self.totalTiers = totalTiers
        self.currentTierName = currentTierName
        self.nextTierName = nextTierName
        self.targetDisplay = targetDisplay
        self.instructions = instructions
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
    }
}
