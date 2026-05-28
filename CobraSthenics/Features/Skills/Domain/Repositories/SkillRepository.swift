import Foundation

public protocol SkillRepository {
    func getSkills() async throws -> [SkillModel]
    func getSkillHistory(skillName: String) async throws -> [SkillSessionEntry]
}
