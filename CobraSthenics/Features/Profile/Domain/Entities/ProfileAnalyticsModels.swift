import Foundation
import SwiftUI

public struct MuscleStat: Identifiable, Codable, Hashable {
    public var id: String { name }
    public let name: String
    public let percent: Int
}

public struct SkillTrend: Identifiable, Codable, Hashable {
    public var id: String { skillName }
    public let skillName: String
    public let values: [Double]
    public let unit: String
    public let colorHex: UInt

    public var latest: Double { values.last ?? 0 }
    public var gain: Double {
        guard let first = values.first, let last = values.last else { return 0 }
        return last - first
    }
    public var color: Color { Color(hex: colorHex) }
}

public struct PrEntry: Identifiable, Codable, Hashable {
    public var id: String { exerciseName }
    public let exerciseName: String
    public let valueDisplay: String
    public let accentHex: UInt

    public var accent: Color { Color(hex: accentHex) }
}

public struct ProfileSnapshot: Codable {
    public let user: UserProfileModel
    public let heatmapGrid: [[Int]]
    public let weeklyVolume: [Double]
    public let personalRecords: [PrEntry]
    public let muscleBreakdown: [MuscleStat]
    public let skillTrends: [SkillTrend]
}
