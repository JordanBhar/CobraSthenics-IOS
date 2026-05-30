import Foundation
import SwiftUI

public enum SettingsRoute: String, Hashable {
    case notifications
    case workoutReminders
    case restTimer
    case appearance
    case language
    case editProfile
    case changePassword
    case connectedApps
    case exportData
    case helpFAQ
    case feedback
    case deleteAccount
    case subscription
    case none
}

public struct SettingGroupPresentationModel: Identifiable, Hashable {
    public var id: String { label }
    public let label: String
    public let items: [SettingItemPresentationModel]
}

public struct SettingItemPresentationModel: Identifiable, Hashable {
    public var id: String { label }
    public let systemImage: String
    public let colorHex: UInt
    public let label: String
    public let value: String?
    public let badge: String?
    public let destructive: Bool
    public let route: SettingsRoute

    public init(
        systemImage: String,
        colorHex: UInt,
        label: String,
        value: String? = nil,
        badge: String? = nil,
        destructive: Bool = false,
        route: SettingsRoute = .none
    ) {
        self.systemImage = systemImage
        self.colorHex = colorHex
        self.label = label
        self.value = value
        self.badge = badge
        self.destructive = destructive
        self.route = route
    }

    public var color: Color { Color(hex: colorHex) }
}
