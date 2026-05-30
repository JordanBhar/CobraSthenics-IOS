//
//  SetType.swift
//  CobraSthenics
//

import Foundation

public enum SetType: String, Codable, CaseIterable {
    case reps
    case timed
    case amrap
    case repsOrTimed
    case unknown
}
