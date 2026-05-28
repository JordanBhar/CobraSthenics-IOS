import Foundation

public final class SampleSkillRepository: SkillRepository {
    public init() {}

    public func getSkills() async throws -> [SkillModel] {
        SampleData.skills
    }

    public func getSkillHistory(skillName: String) async throws -> [SkillSessionEntry] {
        [
            SkillSessionEntry(dateLabel: "Today", valueDisplay: "8.2s", isPR: true),
            SkillSessionEntry(dateLabel: "May 12", valueDisplay: "7.1s", isPR: false),
            SkillSessionEntry(dateLabel: "May 10", valueDisplay: "6.8s", isPR: false),
            SkillSessionEntry(dateLabel: "May 8", valueDisplay: "5.5s", isPR: false)
        ]
    }
}
