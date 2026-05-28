import Foundation

public struct HomeModel: Codable {
    public let user: UserProfileModel
    public let weekDays: [WeekDay]
    public let activeProgram: ActiveProgram?
    public let featuredSkill: SkillModel?
    public let recentWorkouts: [RecentWorkout]
    public let streakDays: Int
}

