import Foundation

public final class SampleHomeRepository: HomeRepository {
    public init() {}

    public func getHomeSnapshot() async throws -> HomeModel {
        HomeModel(
            user: SampleData.user,
            weekDays: SampleData.weekDays,
            activeProgram: SampleData.activeProgram,
            featuredSkill: SampleData.skills.first,
            recentWorkouts: SampleData.recentWorkouts,
            streakDays: 14
        )
    }
}
