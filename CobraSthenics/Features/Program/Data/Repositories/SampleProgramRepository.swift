import Foundation

public final class SampleProgramRepository: ProgramRepository {
    public init() {}

    public func getFeaturedProgram() async throws -> ActiveProgram? {
        SampleData.activeProgram
    }
}
