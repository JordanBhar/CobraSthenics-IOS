//
//  SkillFamily+Display.swift
//  CobraSthenics
//

import SwiftUI

extension SkillFamily {

    var displayName: String {
        switch self {
        case .handstand: return "Handstand"
        case .frontLever: return "Front Lever"
        case .backLever: return "Back Lever"
        case .planche: return "Planche"
        case .humanFlag: return "Human Flag"
        case .muscleUp: return "Muscle-Up"
        }
    }

    var colorPair: ColorPair {
        switch self {
        case .handstand: return ColorPair(0x2B0A4F, 0x5A1A99)
        case .frontLever: return ColorPair(0x0A2E1A, 0x0E5C30)
        case .backLever: return ColorPair(0x001D42, 0x003E8A)
        case .planche: return ColorPair(0x3A0808, 0x7A1010)
        case .humanFlag: return ColorPair(0x2E2000, 0x614400)
        case .muscleUp: return ColorPair(0x002222, 0x004444)
        }
    }

    var accentHex: UInt {
        switch self {
        case .handstand: return 0xBF5AF2
        case .frontLever: return 0x30D158
        case .backLever: return 0x0A84FF
        case .planche: return 0xFF453A
        case .humanFlag: return 0xFFB800
        case .muscleUp: return 0x4DD0E1
        }
    }

    var colors: [Color] { colorPair.colors }
    var accent: Color { Color(hex: accentHex) }
}
