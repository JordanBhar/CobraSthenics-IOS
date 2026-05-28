import Foundation

public final class SampleSettingsRepository: SettingsRepository {
    public init() {}

    public func getSettingGroups() async throws -> [SettingGroupModel] {
        SampleData.settingGroups
    }
}
