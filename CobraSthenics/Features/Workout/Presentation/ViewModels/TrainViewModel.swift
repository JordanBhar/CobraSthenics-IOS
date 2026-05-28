import SwiftUI
import Observation

@Observable
@MainActor
public final class TrainViewModel{
    var activeProgram: ActiveProgram?
    var workouts: [Workout] = []
    var selectedCategory: WorkoutCategory = .all

    private let workoutRepository: any WorkoutRepository

    public init(workoutRepository: any WorkoutRepository) {
        self.workoutRepository = workoutRepository
    }

    var filteredWorkouts: [Workout] {
        selectedCategory == .all ? workouts : workouts.filter { $0.category == selectedCategory }
    }

    func load() async {
        guard workouts.isEmpty else { return }
        activeProgram = try? await workoutRepository.getActiveProgram()
        workouts = (try? await workoutRepository.getWorkouts()) ?? []
    }
}
