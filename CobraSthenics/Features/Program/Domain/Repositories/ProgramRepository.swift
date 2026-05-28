import Foundation

public protocol ProgramRepository {
    func getFeaturedProgram() async throws -> ActiveProgram?
}
