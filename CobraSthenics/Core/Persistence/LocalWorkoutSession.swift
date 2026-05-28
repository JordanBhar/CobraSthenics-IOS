import Foundation
import SwiftData

@available(iOS 17.0, macOS 14.0, *)
@Model
public final class LocalWorkoutSession {
    @Attribute(.unique) public var id: String
    public var name: String
    public var startedAt: Date
    public var completedAt: Date?
    public var pendingSync: Bool

    public init(id: String, name: String, startedAt: Date, completedAt: Date? = nil, pendingSync: Bool = true) {
        self.id = id
        self.name = name
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.pendingSync = pendingSync
    }
}
