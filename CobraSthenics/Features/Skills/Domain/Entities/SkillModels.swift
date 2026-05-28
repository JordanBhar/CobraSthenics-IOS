import Foundation
import SwiftUI

public enum SkillStatus: String, Codable, CaseIterable {
    case active
    case started
    case locked
    case mastered
    case unknown

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = SkillStatus(rawValue: value) ?? .unknown
    }
}

public struct SkillModel: Identifiable, Codable, Hashable {
    public var id: String { name }
    public let name: String
    public let family: String
    public let currentTier: String
    public let nextTier: String
    public let tierIndex: Int
    public let totalTiers: Int
    public let bestDisplay: String?
    public let target: String
    public let progressPercent: Int
    public let colorPair: ColorPair
    public let accentHex: UInt
    public let status: SkillStatus
    public let isStaticHold: Bool
    public let instructions: [String]
    public let primaryMuscles: [String]
    public let secondaryMuscles: [String]

    public var colors: [Color] { colorPair.colors }
    public var accent: Color { Color(hex: accentHex) }
}

public struct SkillSessionEntry: Identifiable, Codable, Hashable {
    public var id: String { "\(dateLabel)-\(valueDisplay)-\(isPR)" }
    public let dateLabel: String
    public let valueDisplay: String
    public let isPR: Bool
}
