import SwiftUI

public struct AppShell: View {

    @State private var selectedTab: AppTab = .home

    public init() {}

    public var body: some View {

        TabView(selection: $selectedTab) {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(NavigationTabConstants.home, systemImage: NavigationTabConstants.homeIconString)
            }
            .tag(AppTab.home)

            NavigationStack {
                WorkoutView()
            }
            .tabItem {
                Label(NavigationTabConstants.workout, systemImage: NavigationTabConstants.workoutIconString)
            }
            .tag(AppTab.workout)

            NavigationStack {
                LibraryView()
            }
            .tabItem {
                Label(NavigationTabConstants.library, systemImage: NavigationTabConstants.libraryIconString)
            }
            .tag(AppTab.library)

            NavigationStack {
                SkillsView()
            }
            .tabItem {
                Label(NavigationTabConstants.skills, systemImage: NavigationTabConstants.skillsIconString)
            }
            .tag(AppTab.skills)

            NavigationStack {
                ProfileView()
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
    case workout
    case library
    case skills
    case profile
}

#Preview {
    AppShell()
}
