//
//  EquipmentType.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-29.
//

import Foundation

enum EquipmentType: String, Codable, CaseIterable {
    case none

    case pullupBar
    case rings
    case parallelBars

    case resistanceBand

    case dumbbell
    case barbell
    case kettlebell

    case wall

    case box

    case other
}
