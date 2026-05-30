import Foundation

@Observable
@MainActor
final class SkillsViewModel {

    var selectedFamily: SkillFamily? = nil

    var familyOptions: [SkillFamily?] {
        [nil] + SkillFamily.allCases
    }

    func visibleSkills(from skills: [Skill]) -> [Skill] {
        guard let selectedFamily else { return skills }
        return skills.filter { $0.family == selectedFamily }
    }
}
