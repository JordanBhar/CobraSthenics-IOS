//
//  SkillStatus.swift
//  CobraSthenics
//

import Foundation

public enum SkillStatus: String, Codable, CaseIterable {
    case active
    case started
    case locked
    case mastered
    case unknown

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = SkillStatus(rawValue: value) ?? .unknown
    }
}
