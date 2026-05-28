import Foundation

public final class SampleUserRepository: UserRepository {
    public init() {}

    public func getUserProfile() async throws -> UserProfileModel {
        SampleData.user
    }

    public func getProfileSnapshot() async throws -> ProfileSnapshot {
        ProfileSnapshot(
            user: SampleData.user,
            heatmapGrid: SampleData.heatmap,
            weeklyVolume: [18, 24, 20, 31, 28, 35, 30],
            personalRecords: SampleData.personalRecords,
            muscleBreakdown: SampleData.muscles,
            skillTrends: SampleData.skillTrends
        )
    }
}
