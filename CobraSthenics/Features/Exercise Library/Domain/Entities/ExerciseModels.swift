import Foundation
import SwiftUI

public enum SetType: String, Codable {
    case reps
    case timed
    case amrap
    case repsOrTimed
    case unknown
}

public struct ExerciseCategory: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let tag: String
    public let exerciseCount: Int
    public let colorPair: ColorPair
    public let accentHex: UInt

    public var colors: [Color] { colorPair.colors }
    public var accent: Color { Color(hex: accentHex) }
}

public struct ProgressionChain: Codable, Hashable {
    public let previousID: String?
    public let nextID: String?
}

public struct PersonalRecord: Codable, Hashable {
    public let bestReps: Int?
    public let bestHoldSeconds: Double?
    public let bestWeightKg: Double?

    public var primaryDisplay: String {
        if let bestHoldSeconds { return String(format: "%.1fs", bestHoldSeconds) }
        if let bestReps { return "\(bestReps) reps" }
        if let bestWeightKg { return "+\(bestWeightKg)kg" }
        return "-"
    }
}

public struct Exercise: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let category: String
    public let mechanics: String
    public let force: String
    public let primaryMuscles: [String]
    public let secondaryMuscles: [String]
    public let equipment: String
    public let difficulty: Difficulty
    public let defaultSetType: SetType
    public let isSkillExercise: Bool
    public let progression: ProgressionChain
    public let description: String
    public let instructions: [String]
    public let tips: [String]
    public let commonMistakes: [String]
    public let personalRecord: PersonalRecord?
    public let colorPair: ColorPair
    public let accentHex: UInt

    public var colors: [Color] { colorPair.colors }
    public var accent: Color { Color(hex: accentHex) }

    public var setTypeLabel: String {
        switch defaultSetType {
        case .timed: return "Timed Hold"
        case .amrap: return "AMRAP"
        case .reps, .repsOrTimed, .unknown: return "Rep Based"
        }
    }
}
