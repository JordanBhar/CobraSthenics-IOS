import Foundation
import SwiftData

@Model
final class User {

    @Attribute(.unique) var id: UUID

    var username: String
    var displayName: String?
    var email: String?

    var avatarURL: String?
    var bio: String?

    // MARK: - Cached Stats
    //
    // Denormalized analytics derived from training history. Kept on `User`
    // so the home/profile screens don't have to recompute on every render.

    var level: Int
    var currentXP: Int
    var xpToNextLevel: Int

    var streakDays: Int
    var longestStreakDays: Int

    var workoutCount: Int
    var activeSkillsCount: Int
    var personalRecordCount: Int

    var isPremium: Bool

    var statsLastRecalculatedAt: Date

    // MARK: - Relationships

    @Relationship(deleteRule: .cascade)
    var userPrograms: [Program] = []

    @Relationship(deleteRule: .cascade)
    var userWorkouts: [Workout] = []

    @Relationship(deleteRule: .cascade, inverse: \WorkoutSession.user)
    var workoutSessions: [WorkoutSession] = []

    @Relationship(deleteRule: .cascade)
    var progressEntries: [ProgressEntry] = []

    @Relationship(deleteRule: .cascade)
    var personalRecords: [PersonalRecord] = []

    @Relationship(deleteRule: .cascade)
    var achievements: [Achievement] = []

    @Relationship(deleteRule: .cascade)
    var programProgress: [UserProgramProgress] = []

    init(
        id: UUID = UUID(),
        username: String,
        displayName: String? = nil,
        email: String? = nil,
        avatarURL: String? = nil,
        bio: String? = nil,
        level: Int = 1,
        currentXP: Int = 0,
        xpToNextLevel: Int = 100,
        streakDays: Int = 0,
        longestStreakDays: Int = 0,
        workoutCount: Int = 0,
        activeSkillsCount: Int = 0,
        personalRecordCount: Int = 0,
        isPremium: Bool = false,
        statsLastRecalculatedAt: Date = .now
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.email = email
        self.avatarURL = avatarURL
        self.bio = bio
        self.level = level
        self.currentXP = currentXP
        self.xpToNextLevel = xpToNextLevel
        self.streakDays = streakDays
        self.longestStreakDays = longestStreakDays
        self.workoutCount = workoutCount
        self.activeSkillsCount = activeSkillsCount
        self.personalRecordCount = personalRecordCount
        self.isPremium = isPremium
        self.statsLastRecalculatedAt = statsLastRecalculatedAt
    }
}
