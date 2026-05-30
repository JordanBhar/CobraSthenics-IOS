import Foundation

@Observable
@MainActor
final class SkillDetailViewModel {

    enum Tab: CaseIterable {
        case instructions, muscles, history

        var title: String {
            switch self {
            case .instructions: return SkillsConstants.Tabs.instructions
            case .muscles: return SkillsConstants.Tabs.muscles
            case .history: return SkillsConstants.Tabs.history
            }
        }
    }

    var selectedTab: Tab = .instructions

    func tierTransition(for skill: Skill) -> String {
        if let next = skill.nextTierName {
            return "\(skill.currentTierName) → \(next)"
        } else {
            return skill.currentTierName
        }
    }
}
