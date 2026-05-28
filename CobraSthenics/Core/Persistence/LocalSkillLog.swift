import Foundation
import SwiftData

@available(iOS 17.0, macOS 14.0, *)
@Model
public final class LocalSkillLog {
    @Attribute(.unique) public var id: String
    public var skillID: String
    public var skillName: String
    public var bestHoldSeconds: Int
    public var createdAt: Date
    public var pendingSync: Bool

    public init(id: String, skillID: String, skillName: String, bestHoldSeconds: Int, createdAt: Date = .now, pendingSync: Bool = true) {
        self.id = id
        self.skillID = skillID
        self.skillName = skillName
        self.bestHoldSeconds = bestHoldSeconds
        self.createdAt = createdAt
        self.pendingSync = pendingSync
    }
}
