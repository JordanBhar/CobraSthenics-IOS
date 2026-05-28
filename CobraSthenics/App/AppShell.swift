import SwiftUI

public struct AppShell: View {

    @Environment(AppEnvironment.self) private var environment

    @State private var selectedTab: AppTab = .home

    public init() {}

    public var body: some View {

        TabView(selection: $selectedTab) {

            NavigationStack {
                HomeView(
                    viewModel: HomeViewModel(
                        homeRepository: environment.homeRepository
                    )
                )
            }
            .tabItem {
                Label(NavigationTabConstants.home, systemImage: NavigationTabConstants.homeIconString)
            }
            .tag(AppTab.home)

            NavigationStack {
                TrainView(
                    viewModel: TrainViewModel(
                        workoutRepository: environment.workoutRepository
                    )
                )
            }
            .tabItem {
                Label(NavigationTabConstants.train, systemImage: NavigationTabConstants.trainIconString)
            }
            .tag(AppTab.train)

            NavigationStack {
                LibraryView(
                    viewModel: LibraryViewModel(
                        exerciseRepository: environment.exerciseRepository
                    )
                )
            }
            .tabItem {
                Label(NavigationTabConstants.library, systemImage: NavigationTabConstants.libraryIconString)
            }
            .tag(AppTab.library)

            NavigationStack {
                SkillsView(
                    viewModel: SkillsViewModel(
                        skillRepository: environment.skillRepository
                    )
                )
            }
            .tabItem {
                Label(NavigationTabConstants.skills, systemImage: NavigationTabConstants.skillsIconString)
            }
            .tag(AppTab.skills)

            NavigationStack {
                ProfileView(
                    viewModel: ProfileViewModel(
                        userRepository: environment.userRepository,
                        settingsRepository: environment.settingsRepository
                    )
                )
            }
            .tabItem {
                Label(NavigationTabConstants.profile, systemImage: NavigationTabConstants.profileIconString)
            }
            .tag(AppTab.profile)
        }
        .tint(AppColor.brand)
        .background(AppColor.background)
    }
}

private enum AppTab: Hashable {
    case home
    case train
    case library
    case skills
    case profile
}

#Preview {
    AppShell()
        .environment(AppEnvironment.preview)
}
