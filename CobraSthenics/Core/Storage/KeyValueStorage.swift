import Foundation

public protocol KeyValueStorage {
    func string(forKey key: String) -> String?
    func set(_ value: String?, forKey key: String)
}

extension UserDefaults: KeyValueStorage {
    public func set(_ value: String?, forKey key: String) {
        set(value as Any?, forKey: key)
    }
}
