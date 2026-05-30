//
//  EquipmentType+Display.swift
//  CobraSthenics
//

import Foundation

extension EquipmentType {

    var displayName: String {
        switch self {
        case .none: return "Bodyweight"
        case .pullupBar: return "Pull-Up Bar"
        case .rings: return "Rings"
        case .parallelBars: return "Parallel Bars"
        case .resistanceBand: return "Resistance Band"
        case .dumbbell: return "Dumbbell"
        case .barbell: return "Barbell"
        case .kettlebell: return "Kettlebell"
        case .wall: return "Wall"
        case .box: return "Box"
        case .other: return "Other"
        }
    }
}
