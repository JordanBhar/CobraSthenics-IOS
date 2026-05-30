import Foundation
import SwiftData

@Model
final class Exercise {

    // MARK: - Identity

    @Attribute(.unique) var id: UUID

    /// Stable identifier from the backend (Firestore doc ID, etc.).
    /// `nil` means this entity has been created locally and not yet synced.
    var externalID: String?

    // MARK: - Basic Information

    var name: String
    var exerciseDescription: String

    // MARK: - Classification

    var category: ExerciseCategory

    var difficulty: Difficulty

    var primaryMuscleGroups: [MuscleGroup]
    var secondaryMuscleGroups: [MuscleGroup]

    var equipment: EquipmentType

    var mechanics: ExerciseMechanic

    var force: ForceType
    
    var skillFamily: SkillFamily?

    // MARK: - Exercise Metadata

    var isSkillExercise: Bool

    // MARK: - Instructions

    var instructions: [String]

    var tips: [String]

    var commonMistakes: [String]

    // MARK: - Media

    var videoURL: String?
    var thumbnailURL: String?

    // MARK: - Progression

    var previousExerciseID: UUID?
    var nextExerciseID: UUID?

    init(
        id: UUID = UUID(),
        externalID: String? = nil,

        name: String,
        exerciseDescription: String,

        category: ExerciseCategory,

        difficulty: Difficulty,

        primaryMuscleGroups: [MuscleGroup] = [],
        secondaryMuscleGroups: [MuscleGroup] = [],

        equipment: EquipmentType = .none,

        mechanics: ExerciseMechanic,

        force: ForceType,

        skillFamily: SkillFamily? = nil,

        isSkillExercise: Bool = false,

        instructions: [String] = [],
        tips: [String] = [],
        commonMistakes: [String] = [],

        videoURL: String? = nil,
        thumbnailURL: String? = nil,

        previousExerciseID: UUID? = nil,
        nextExerciseID: UUID? = nil
    ) {
        self.id = id
        self.externalID = externalID

        self.name = name
        self.exerciseDescription = exerciseDescription

        self.category = category

        self.difficulty = difficulty

        self.primaryMuscleGroups = primaryMuscleGroups
        self.secondaryMuscleGroups = secondaryMuscleGroups

        self.equipment = equipment

        self.mechanics = mechanics
        self.force = force

        self.skillFamily = skillFamily

        self.isSkillExercise = isSkillExercise

        self.instructions = instructions
        self.tips = tips
        self.commonMistakes = commonMistakes

        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL

        self.previousExerciseID = previousExerciseID
        self.nextExerciseID = nextExerciseID
    }
}
