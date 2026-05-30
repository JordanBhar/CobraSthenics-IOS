//
//  User+Display.swift
//  CobraSthenics
//

import Foundation

extension User {

    /// Human-readable rank derived from the numeric `level`.
    var levelTitle: String {
        switch level {
        case ..<5: return "Beginner"
        case ..<10: return "Apprentice"
        case ..<20: return "Athlete"
        case ..<30: return "Ring Master"
        default: return "Cobra"
        }
    }

    /// 0...1 progress towards the next level.
    var xpProgress: Double {
        guard xpToNextLevel > 0 else { return 0 }
        return min(1, Double(currentXP) / Double(xpToNextLevel))
    }
}
