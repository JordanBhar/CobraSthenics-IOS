import Foundation
import SwiftData

@available(iOS 17.0, macOS 14.0, *)
@Model
public final class LocalExerciseCache {
    @Attribute(.unique) public var id: String
    public var name: String
    public var category: String
    public var encodedPayload: Data
    public var updatedAt: Date

    public init(id: String, name: String, category: String, encodedPayload: Data, updatedAt: Date = .now) {
        self.id = id
        self.name = name
        self.category = category
        self.encodedPayload = encodedPayload
        self.updatedAt = updatedAt
    }
}
