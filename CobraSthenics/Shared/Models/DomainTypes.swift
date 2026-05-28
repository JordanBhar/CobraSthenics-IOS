import Foundation
import SwiftUI

public enum Difficulty: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case elite
    case unknown

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = Difficulty(rawValue: value) ?? .unknown
    }

    public var title: String {
        rawValue.prefix(1).uppercased() + String(rawValue.dropFirst())
    }
}

public struct ColorPair: Codable, Hashable {
    public let firstHex: UInt
    public let secondHex: UInt

    public init(_ firstHex: UInt, _ secondHex: UInt) {
        self.firstHex = firstHex
        self.secondHex = secondHex
    }

    public var colors: [Color] {
        [Color(hex: firstHex), Color(hex: secondHex)]
    }
}

public struct WeekDay: Identifiable, Codable, Hashable {
    public let id: String
    public let label: String
    public let completed: Bool
    public let isToday: Bool

    public init(id: String = UUID().uuidString, label: String, completed: Bool, isToday: Bool = false) {
        self.id = id
        self.label = label
        self.completed = completed
        self.isToday = isToday
    }
}
