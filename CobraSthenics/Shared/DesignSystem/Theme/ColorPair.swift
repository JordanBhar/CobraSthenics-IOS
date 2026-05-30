//
//  ColorPair.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-28.
//
import SwiftUI

public struct ColorPair: Codable, Hashable {
    public let firstHex: UInt
    public let secondHex: UInt

    public init(_ firstHex: UInt, _ secondHex: UInt) {
        self.firstHex = firstHex
        self.secondHex = secondHex
    }

    public var colors: [Color] {
        [Color(hex: firstHex), Color(hex: secondHex)]
    }
}
