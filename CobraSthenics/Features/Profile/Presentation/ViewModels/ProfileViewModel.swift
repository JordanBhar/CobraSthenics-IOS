import SwiftUI
import Observation

@MainActor
@Observable

public final class ProfileViewModel{
    var snapshot: ProfileSnapshot?
    var settingGroups: [SettingGroupModel] = []
    var selectedProgressTab = 0

    private let userRepository: any UserRepository
    private let settingsRepository: any SettingsRepository

    public init(
        userRepository: any UserRepository,
        settingsRepository: any SettingsRepository
    ) {
        self.userRepository = userRepository
        self.settingsRepository = settingsRepository
    }

    func load() async {
        guard snapshot == nil else { return }
        snapshot = try? await userRepository.getProfileSnapshot()
        settingGroups = (try? await settingsRepository.getSettingGroups()) ?? []
    }
}
