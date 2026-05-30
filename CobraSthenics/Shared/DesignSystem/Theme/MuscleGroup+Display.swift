//
//  MuscleGroup+Display.swift
//  CobraSthenics
//

import Foundation

extension MuscleGroup {

    var displayName: String {
        switch self {
        case .chest: return "Chest"
        case .back: return "Back"
        case .shoulders: return "Shoulders"
        case .biceps: return "Biceps"
        case .triceps: return "Triceps"
        case .legs: return "Legs"
        case .core: return "Core"
        case .forearms: return "Forearms"
        case .fullBody: return "Full Body"
        }
    }
}
