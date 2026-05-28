import Foundation
import Observation

@Observable
@MainActor
public final class AppEnvironment {

    public let homeRepository: any HomeRepository
    public let userRepository: any UserRepository
    public let settingsRepository: any SettingsRepository
    public let workoutRepository: any WorkoutRepository
    public let skillRepository: any SkillRepository
    public let exerciseRepository: any ExerciseRepository
    public let programRepository: any ProgramRepository

    public init(
        homeRepository: any HomeRepository,
        userRepository: any UserRepository,
        settingsRepository: any SettingsRepository,
        workoutRepository: any WorkoutRepository,
        skillRepository: any SkillRepository,
        exerciseRepository: any ExerciseRepository,
        programRepository: any ProgramRepository
    ) {
        self.homeRepository = homeRepository
        self.userRepository = userRepository
        self.settingsRepository = settingsRepository
        self.workoutRepository = workoutRepository
        self.skillRepository = skillRepository
        self.exerciseRepository = exerciseRepository
        self.programRepository = programRepository
    }

    public static let preview = AppEnvironment(
        homeRepository: SampleHomeRepository(),
        userRepository: SampleUserRepository(),
        settingsRepository: SampleSettingsRepository(),
        workoutRepository: SampleWorkoutRepository(),
        skillRepository: SampleSkillRepository(),
        exerciseRepository: SampleExerciseRepository(),
        programRepository: SampleProgramRepository()
    )
}
