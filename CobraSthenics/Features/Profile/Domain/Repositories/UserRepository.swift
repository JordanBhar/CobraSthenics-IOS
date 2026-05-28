import Foundation

public protocol UserRepository {
    func getUserProfile() async throws -> UserProfileModel
    func getProfileSnapshot() async throws -> ProfileSnapshot
}
