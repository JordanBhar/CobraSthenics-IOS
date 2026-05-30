//
//  WorkoutCategory.swift
//  CobraSthenics
//

import Foundation

public enum WorkoutCategory: String, Codable, CaseIterable {
    case all
    case strength
    case skill
    case mobility
    case rings
    case unknown

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = WorkoutCategory(rawValue: value) ?? .unknown
    }

    public var title: String {
        switch self {
        case .all: return "All Workouts"
        case .strength: return "Strength"
        case .skill: return "Skill"
        case .mobility: return "Mobility"
        case .rings: return "Rings"
        case .unknown: return "Other"
        }
    }
}
