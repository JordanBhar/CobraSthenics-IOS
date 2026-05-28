import Foundation

public final class SampleWorkoutRepository: WorkoutRepository {
    public init() {}

    public func getActiveProgram() async throws -> ActiveProgram? {
        SampleData.activeProgram
    }

    public func getWorkouts() async throws -> [Workout] {
        SampleData.workouts
    }
}
