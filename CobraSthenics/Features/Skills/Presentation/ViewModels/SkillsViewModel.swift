import SwiftUI
import Observation

@Observable
@MainActor
public final class SkillsViewModel{
    var skills: [SkillModel] = []
    var selectedFamily = "all"

    private let skillRepository: any SkillRepository

    public init(skillRepository: any SkillRepository) {
        self.skillRepository = skillRepository
    }

    var families: [String] {
        ["all"] + Array(Set(skills.map(\.family))).sorted()
    }

    var filteredSkills: [SkillModel] {
        selectedFamily == "all" ? skills : skills.filter { $0.family == selectedFamily }
    }

    func count(_ status: SkillStatus) -> Int {
        skills.filter { $0.status == status }.count
    }

    func load() async {
        guard skills.isEmpty else { return }
        skills = (try? await skillRepository.getSkills()) ?? []
    }
}
