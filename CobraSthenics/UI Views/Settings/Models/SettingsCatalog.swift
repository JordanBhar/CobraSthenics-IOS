//
//  SettingsCatalog.swift
//  CobraSthenics
//

import Foundation

/// Static UI catalog of settings groups shown in the profile/settings screens.
/// Per-item display values (e.g. "2:00", "Dark") are placeholders and should
/// eventually read from user preferences via `KeyValueStorage`.
enum SettingsCatalog {

    static let groups: [SettingGroupPresentationModel] = [
        SettingGroupPresentationModel(label: "Account", items: [
            SettingItemPresentationModel(systemImage: "square.and.pencil", colorHex: 0x0A84FF, label: "Edit Profile", route: .editProfile),
            SettingItemPresentationModel(systemImage: "lock", colorHex: 0x30D158, label: "Change Password", route: .changePassword),
            SettingItemPresentationModel(systemImage: "bell", colorHex: 0xFF9F0A, label: "Notifications", route: .notifications),
            SettingItemPresentationModel(systemImage: "timer", colorHex: 0x0A84FF, label: "Default Rest Timer", value: "2:00", route: .restTimer),
            SettingItemPresentationModel(systemImage: "calendar.badge.clock", colorHex: 0xFF9F0A, label: "Workout Reminders", value: "Mon · Wed · Fri", route: .workoutReminders)
        ]),
        SettingGroupPresentationModel(label: "App", items: [
            SettingItemPresentationModel(systemImage: "sun.max", colorHex: 0xBF5AF2, label: "Appearance", value: "Dark", route: .appearance),
            SettingItemPresentationModel(systemImage: "globe", colorHex: 0x4DD0E1, label: "Language", value: "English", route: .language),
            SettingItemPresentationModel(systemImage: "iphone.gen3", colorHex: 0x4DD0E1, label: "Connected Apps", value: "2 active", route: .connectedApps),
            SettingItemPresentationModel(systemImage: "square.and.arrow.down", colorHex: 0x0A84FF, label: "Export Data", route: .exportData),
            SettingItemPresentationModel(systemImage: "star.fill", colorHex: 0xFFB800, label: "Subscription", badge: "Premium", route: .subscription)
        ]),
        SettingGroupPresentationModel(label: "Support", items: [
            SettingItemPresentationModel(systemImage: "questionmark.circle", colorHex: 0xBF5AF2, label: "Help & FAQ", route: .helpFAQ),
            SettingItemPresentationModel(systemImage: "message", colorHex: 0x0A84FF, label: "Send Feedback", route: .feedback),
            SettingItemPresentationModel(systemImage: "trash", colorHex: 0xFF453A, label: "Delete Account", destructive: true, route: .deleteAccount)
        ])
    ]
}
