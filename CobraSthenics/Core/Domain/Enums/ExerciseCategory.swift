//
//  ExerciseCategory.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-29.
//

import Foundation

/// Higher-level movement pattern / programming bucket for an exercise.
/// Use `primaryMuscleGroups` for muscle-level detail.
enum ExerciseCategory: String, Codable, CaseIterable {
    case push
    case pull
    case legs
    case core
    case skill
    case mobility
    case fullBody
    case conditioning
    case unknown
}
