//
//  PreviewModelContainer.swift
//  CobraSthenics
//

import Foundation
import SwiftData

/// In-memory `ModelContainer` used by SwiftUI `#Preview` blocks.
/// Reuses `Seeder` so previews see the same canonical data as a fresh app launch.
@MainActor
enum PreviewModelContainer {

    static let shared: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for:
                User.self,
                UserProgramProgress.self,
                UserExercise.self,
                Achievement.self,
                Exercise.self,
                Workout.self,
                WorkoutExercise.self,
                WorkoutSession.self,
                WorkoutSessionExercise.self,
                Program.self,
                Skill.self,
                ProgressEntry.self,
                PersonalRecord.self,
            configurations: configuration
        )
        Seeder.seedIfEmpty(container.mainContext)
        return container
    }()
}
