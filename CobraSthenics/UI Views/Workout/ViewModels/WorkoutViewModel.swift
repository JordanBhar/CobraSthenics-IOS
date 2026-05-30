import Foundation

@Observable
@MainActor
final class WorkoutViewModel {

    var selectedCategory: WorkoutCategory = .all

    func filteredWorkouts(from workouts: [Workout]) -> [Workout] {
        selectedCategory == .all ? workouts : workouts.filter { $0.category == selectedCategory }
    }

    func primaryMuscleNames(for workout: Workout, limit: Int = 3) -> [String] {
        var seen: Set<MuscleGroup> = []
        var ordered: [MuscleGroup] = []
        for workoutExercise in workout.exercises.sorted(by: { $0.orderIndex < $1.orderIndex }) {
            for muscle in workoutExercise.exercise?.primaryMuscleGroups ?? [] {
                if seen.insert(muscle).inserted { ordered.append(muscle) }
            }
        }
        return Array(ordered.prefix(limit)).map(\.displayName)
    }

    func durationLabel(for workout: Workout) -> String {
        guard let minutes = workout.estimatedDurationMinutes else { return "—" }
        return "\(minutes) min"
    }
}
