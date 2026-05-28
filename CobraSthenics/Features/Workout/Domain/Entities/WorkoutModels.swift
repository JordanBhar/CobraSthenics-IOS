import Foundation
import SwiftUI

public enum WorkoutCategory: String, Codable, CaseIterable {
    case all
    case strength
    case skill
    case mobility
    case rings
    case unknown

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = WorkoutCategory(rawValue: value) ?? .unknown
    }

    public var title: String {
        switch self {
        case .all: return "All Workouts"
        case .strength: return "Strength"
        case .skill: return "Skill"
        case .mobility: return "Mobility"
        case .rings: return "Rings"
        case .unknown: return "Other"
        }
    }
}

public struct RecentWorkout: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let dateLabel: String
    public let setCount: Int
    public let duration: String
    public let isSkillSession: Bool
    public let backgroundHex: UInt
    public let accentHex: UInt

    public var background: Color { Color(hex: backgroundHex) }
    public var accent: Color { Color(hex: accentHex) }
}

public struct Workout: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let duration: String
    public let exerciseCount: Int
    public let muscles: [String]
    public let level: String
    public let colorPair: ColorPair
    public let accentHex: UInt
    public let category: WorkoutCategory
    public let exercises: [Exercise]

    public var colors: [Color] { colorPair.colors }
    public var accent: Color { Color(hex: accentHex) }
}
