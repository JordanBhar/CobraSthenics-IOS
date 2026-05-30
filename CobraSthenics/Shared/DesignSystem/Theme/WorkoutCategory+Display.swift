//
//  WorkoutCategory+Display.swift
//  CobraSthenics
//

import SwiftUI

extension WorkoutCategory {

    /// Filter-bar options. `.all` is the "no filter" sentinel; the other cases
    /// are valid storage values for a `Workout.category`.
    static var filterOptions: [WorkoutCategory] {
        [.all, .strength, .skill, .mobility, .rings]
    }

    var colorPair: ColorPair {
        switch self {
        case .strength: return ColorPair(0x001D42, 0x003E8A)
        case .skill: return ColorPair(0x2B0A4F, 0x5A1A99)
        case .mobility: return ColorPair(0x002222, 0x004444)
        case .rings: return ColorPair(0x2E2000, 0x614400)
        case .all, .unknown: return ColorPair(0x1A1A1A, 0x2A2A2A)
        }
    }

    var accentHex: UInt {
        switch self {
        case .strength: return 0x0A84FF
        case .skill: return 0xBF5AF2
        case .mobility: return 0x4DD0E1
        case .rings: return 0xFFB800
        case .all, .unknown: return 0x8A8A8A
        }
    }

    var colors: [Color] { colorPair.colors }
    var accent: Color { Color(hex: accentHex) }
}

extension Difficulty {
    /// Color used by the workout-tile difficulty pill and similar chips.
    var pillColor: Color {
        switch self {
        case .beginner: return AppColor.green
        case .intermediate: return AppColor.orange
        case .advanced: return AppColor.red
        case .elite: return AppColor.purple
        case .unknown: return AppColor.textSecondary
        }
    }
}
