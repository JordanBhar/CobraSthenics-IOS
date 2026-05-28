import Foundation

public protocol SettingsRepository {
    func getSettingGroups() async throws -> [SettingGroupModel]
}
