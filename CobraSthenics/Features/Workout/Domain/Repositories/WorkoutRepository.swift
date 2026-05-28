import Foundation

public protocol WorkoutRepository {
    func getActiveProgram() async throws -> ActiveProgram?
    func getWorkouts() async throws -> [Workout]
}
