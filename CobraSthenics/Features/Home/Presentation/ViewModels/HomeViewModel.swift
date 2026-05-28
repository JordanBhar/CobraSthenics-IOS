import SwiftUI
import Observation

@Observable
@MainActor
public final class HomeViewModel{
    var homedata: HomeModel?
    var isLoading = false

    private let homeRepository: any HomeRepository

    public init(homeRepository: any HomeRepository) {
        self.homeRepository = homeRepository
    }

    func load() async {
        guard homedata == nil else { return }
        isLoading = true
        defer { isLoading = false }
        homedata = try? await homeRepository.getHomeSnapshot()
    }
}
