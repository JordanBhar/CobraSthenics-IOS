import Foundation

public protocol HomeRepository {
    func getHomeSnapshot() async throws -> HomeModel
}
