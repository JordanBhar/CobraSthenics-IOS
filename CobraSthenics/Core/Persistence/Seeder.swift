//
//  Seeder.swift
//  CobraSthenics
//

import Foundation
import SwiftData

/// First-launch seeding for the canonical catalog (exercises, skills, sample
/// programs) and the local user record. Idempotent: each section only inserts
/// if its corresponding entity is empty.
enum Seeder {

    static func seedIfEmpty(_ context: ModelContext) {
        seedExercisesIfEmpty(context)
        seedSkillsIfEmpty(context)
        seedUserIfEmpty(context)
        seedProgramsIfEmpty(context)

        do {
            try context.save()
        } catch {
            assertionFailure("Seeder save failed: \(error)")
        }
    }

    // MARK: - Exercises

    private static func seedExercisesIfEmpty(_ context: ModelContext) {
        guard (try? context.fetchCount(FetchDescriptor<Exercise>())) == 0 else { return }

        for exercise in seedExercises() {
            context.insert(exercise)
        }
    }

    private static func seedExercises() -> [Exercise] {
        let pushUp = Exercise(
            name: "Push-Up",
            exerciseDescription: "Classic horizontal push pattern.",
            category: .push,
            difficulty: .beginner,
            primaryMuscleGroups: [.chest],
            secondaryMuscleGroups: [.triceps, .shoulders],
            equipment: .none,
            mechanics: .compound,
            force: .push,
            isSkillExercise: false,
            instructions: [
                "Set hands under shoulders.",
                "Brace core.",
                "Lower with control.",
                "Press back to lockout."
            ],
            tips: ["Keep ribs down."],
            commonMistakes: ["Sagging hips"]
        )

        let pullUp = Exercise(
            name: "Pull-Up",
            exerciseDescription: "Vertical pulling benchmark.",
            category: .pull,
            difficulty: .intermediate,
            primaryMuscleGroups: [.back],
            secondaryMuscleGroups: [.biceps],
            equipment: .pullupBar,
            mechanics: .compound,
            force: .pull,
            isSkillExercise: false,
            instructions: [
                "Hang from bar.",
                "Pull elbows to ribs.",
                "Clear chin over bar.",
                "Lower under control."
            ],
            tips: ["Start with scapular depression."],
            commonMistakes: ["Kipping early"]
        )

        let lSit = Exercise(
            name: "L-Sit",
            exerciseDescription: "Compression hold for core and support strength.",
            category: .core,
            difficulty: .advanced,
            primaryMuscleGroups: [.core],
            secondaryMuscleGroups: [.triceps],
            equipment: .parallelBars,
            mechanics: .staticHold,
            force: .isometric,
            isSkillExercise: true,
            instructions: [
                "Press to support.",
                "Depress shoulders.",
                "Lift straight legs.",
                "Hold tension."
            ],
            tips: ["Point toes."],
            commonMistakes: ["Bent elbows"]
        )

        let dip = Exercise(
            name: "Dip",
            exerciseDescription: "Bodyweight pressing on parallel bars.",
            category: .push,
            difficulty: .intermediate,
            primaryMuscleGroups: [.chest, .triceps],
            secondaryMuscleGroups: [.shoulders],
            equipment: .parallelBars,
            mechanics: .compound,
            force: .push,
            instructions: [
                "Support on bars.",
                "Lower until shoulders below elbows.",
                "Press back to lockout."
            ]
        )

        let pistolSquat = Exercise(
            name: "Pistol Squat",
            exerciseDescription: "Single-leg squat.",
            category: .legs,
            difficulty: .advanced,
            primaryMuscleGroups: [.legs],
            secondaryMuscleGroups: [.core],
            equipment: .none,
            mechanics: .compound,
            force: .squat,
            instructions: [
                "Stand on one leg.",
                "Extend free leg forward.",
                "Squat under control.",
                "Drive back to standing."
            ]
        )

        return [pushUp, pullUp, lSit, dip, pistolSquat]
    }

    // MARK: - Skills

    private static func seedSkillsIfEmpty(_ context: ModelContext) {
        guard (try? context.fetchCount(FetchDescriptor<Skill>())) == 0 else { return }

        let frontLever = Skill(
            name: "Front Lever",
            skillDescription: "Horizontal hold from the bar, body facing up.",
            family: .frontLever,
            difficulty: .advanced,
            primaryMuscleGroups: [.back, .core],
            secondaryMuscleGroups: [.biceps],
            isStaticHold: true,
            tierIndex: 2,
            totalTiers: 5,
            currentTierName: "Tuck",
            nextTierName: "Adv. Tuck",
            targetDisplay: "10s",
            instructions: [
                "Hang from bar with overhand grip.",
                "Depress and retract scapulae.",
                "Push bar toward hips to raise body horizontal.",
                "Hold with hips level."
            ]
        )

        let handstand = Skill(
            name: "Handstand",
            skillDescription: "Full-body inverted balance.",
            family: .handstand,
            difficulty: .intermediate,
            primaryMuscleGroups: [.shoulders, .core],
            secondaryMuscleGroups: [.forearms],
            isStaticHold: true,
            tierIndex: 2,
            totalTiers: 6,
            currentTierName: "Wall Supported",
            nextTierName: "Kick-Up",
            targetDisplay: "60s",
            instructions: [
                "Hands close to wall.",
                "Kick up with control.",
                "Stack wrists, shoulders, hips, ankles.",
                "Push the floor away."
            ]
        )

        context.insert(frontLever)
        context.insert(handstand)
    }

    // MARK: - User

    private static func seedUserIfEmpty(_ context: ModelContext) {
        guard (try? context.fetchCount(FetchDescriptor<User>())) == 0 else { return }

        let user = User(
            username: "athlete",
            displayName: "New Athlete"
        )

        context.insert(user)
    }

    // MARK: - Programs

    private static func seedProgramsIfEmpty(_ context: ModelContext) {
        guard (try? context.fetchCount(FetchDescriptor<Program>())) == 0 else { return }

        let program = Program(
            name: "Calisthenics Foundations",
            programDescription: "An 8-week introduction to the fundamentals.",
            difficulty: .beginner,
            durationWeeks: 8,
            workoutsPerWeek: 3
        )
        context.insert(program)

        let exercisesByName = exerciseLookup(in: context)
        let workouts = seedWorkouts(exercisesByName: exercisesByName)
        for workout in workouts {
            context.insert(workout)
            program.workouts.append(workout)
        }

        if let user = try? context.fetch(FetchDescriptor<User>()).first {
            let progress = UserProgramProgress(
                program: program,
                currentWeek: 2,
                currentDay: 1,
                adherencePercent: 65,
                isActive: true
            )
            context.insert(progress)
            user.programProgress.append(progress)
        }
    }

    private static func exerciseLookup(in context: ModelContext) -> [String: Exercise] {
        let exercises = (try? context.fetch(FetchDescriptor<Exercise>())) ?? []
        return Dictionary(uniqueKeysWithValues: exercises.map { ($0.name, $0) })
    }

    private static func seedWorkouts(exercisesByName: [String: Exercise]) -> [Workout] {
        let pushDay = Workout(
            name: "Push Day",
            workoutDescription: "Horizontal and vertical pressing.",
            category: .strength,
            difficulty: .beginner,
            estimatedDurationMinutes: 35
        )
        attach(exercise: exercisesByName["Push-Up"], to: pushDay, sets: 4, reps: 10, order: 0)
        attach(exercise: exercisesByName["Dip"], to: pushDay, sets: 3, reps: 8, order: 1)

        let pullDay = Workout(
            name: "Pull Day",
            workoutDescription: "Vertical pulling foundation.",
            category: .strength,
            difficulty: .intermediate,
            estimatedDurationMinutes: 40
        )
        attach(exercise: exercisesByName["Pull-Up"], to: pullDay, sets: 5, reps: 5, order: 0)

        let skillSession = Workout(
            name: "Skill Session",
            workoutDescription: "Static-hold and balance work.",
            category: .skill,
            difficulty: .advanced,
            estimatedDurationMinutes: 25
        )
        attach(
            exercise: exercisesByName["L-Sit"],
            to: skillSession,
            setType: .timed,
            sets: 4,
            targetSeconds: 15,
            order: 0
        )

        return [pushDay, pullDay, skillSession]
    }

    private static func attach(
        exercise: Exercise?,
        to workout: Workout,
        setType: SetType = .reps,
        sets: Int,
        reps: Int? = nil,
        targetSeconds: Double? = nil,
        order: Int
    ) {
        guard let exercise else { return }
        let workoutExercise = WorkoutExercise(
            exercise: exercise,
            setType: setType,
            sets: sets,
            reps: reps,
            targetSeconds: targetSeconds,
            orderIndex: order
        )
        workout.exercises.append(workoutExercise)
    }
}
