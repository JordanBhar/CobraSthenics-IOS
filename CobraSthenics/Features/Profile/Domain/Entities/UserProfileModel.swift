import Foundation

public struct UserProfileModel: Identifiable, Codable, Hashable {
    public let id: String
    public let displayName: String
    public let username: String
    public let avatarURL: URL?
    public let level: Int
    public let levelTitle: String
    public let currentXP: Int
    public let xpToNextLevel: Int
    public let workoutCount: Int
    public let streakDays: Int
    public let activeSkills: Int
    public let prCount: Int
    public let isPremium: Bool
    public let bio: String?
    public let achievements: [Achievement]

    public var xpProgress: Double {
        guard xpToNextLevel > 0 else { return 0 }
        return Double(currentXP) / Double(xpToNextLevel)
    }
}

public struct Achievement: Identifiable, Codable, Hashable {
    public let id: String
    public let emoji: String
    public let name: String
    public let isEarned: Bool
}
