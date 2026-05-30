//
//  CobraSthenicsApp.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-25.
//

import SwiftUI
import SwiftData

@main
struct CobraSthenicsApp: App {

    var body: some Scene {

        WindowGroup {

            RootView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [
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
            PersonalRecord.self
        ])
    }
    
    
    
}

private struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        AppShell()
            .task {
                Seeder.seedIfEmpty(modelContext)
            }
    }
}

#Preview {
    AppShell()
}
