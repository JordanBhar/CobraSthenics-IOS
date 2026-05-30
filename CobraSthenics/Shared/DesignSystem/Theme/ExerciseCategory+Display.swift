//
//  ExerciseCategory+Display.swift
//  CobraSthenics
//

import SwiftUI

extension ExerciseCategory {

    var title: String {
        switch self {
        case .push: return "Push"
        case .pull: return "Pull"
        case .legs: return "Legs"
        case .core: return "Core"
        case .skill: return "Skill"
        case .mobility: return "Mobility"
        case .fullBody: return "Full Body"
        case .conditioning: return "Conditioning"
        case .unknown: return "Other"
        }
    }

    var tag: String {
        switch self {
        case .push: return "Press"
        case .pull: return "Pull"
        case .legs: return "Squat"
        case .core: return "Static"
        case .skill: return "Skill"
        case .mobility: return "Stretch"
        case .fullBody: return "Compound"
        case .conditioning: return "Cardio"
        case .unknown: return "Other"
        }
    }

    var colorPair: ColorPair {
        switch self {
        case .push: return ColorPair(0x001D42, 0x003E8A)
        case .pull: return ColorPair(0x0A2E1A, 0x0E5C30)
        case .legs: return ColorPair(0x2E2000, 0x614400)
        case .core: return ColorPair(0x3A0808, 0x7A1010)
        case .skill: return ColorPair(0x2B0A4F, 0x5A1A99)
        case .mobility: return ColorPair(0x002222, 0x004444)
        case .fullBody: return ColorPair(0x001830, 0x003366)
        case .conditioning: return ColorPair(0x3A1500, 0x7A2D00)
        case .unknown: return ColorPair(0x1A1A1A, 0x2A2A2A)
        }
    }

    var accentHex: UInt {
        switch self {
        case .push: return 0x0A84FF
        case .pull: return 0x30D158
        case .legs: return 0xFFB800
        case .core: return 0xFF453A
        case .skill: return 0xBF5AF2
        case .mobility: return 0x4DD0E1
        case .fullBody: return 0x4DD0E1
        case .conditioning: return 0xFF9F0A
        case .unknown: return 0x8A8A8A
        }
    }

    var colors: [Color] { colorPair.colors }
    var accent: Color { Color(hex: accentHex) }
}
