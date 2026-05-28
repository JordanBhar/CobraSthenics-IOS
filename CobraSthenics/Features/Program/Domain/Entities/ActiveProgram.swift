import Foundation
import SwiftUI

public struct ActiveProgram: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let currentWeek: Int
    public let totalWeeks: Int
    public let currentDay: Int
    public let totalDays: Int
    public let adherencePercent: Int
    public let level: String
    public let workouts: [Workout]
    public let colorPair: ColorPair
    public let accentHex: UInt

    public var colors: [Color] { colorPair.colors }
    public var accent: Color { Color(hex: accentHex) }
}
