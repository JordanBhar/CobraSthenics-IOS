//
//  Difficulty.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-28.
//

public enum Difficulty: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case elite
    case unknown

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = Difficulty(rawValue: value) ?? .unknown
    }

    public var title: String {
        rawValue.prefix(1).uppercased() + String(rawValue.dropFirst())
    }
}
