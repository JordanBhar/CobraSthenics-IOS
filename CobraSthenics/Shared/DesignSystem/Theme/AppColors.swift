//
//  AppColors.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-26.
//
import SwiftUI

public enum AppColor {
    public static let background = Color(hex: 0x080808)
    public static let card = Color(hex: 0x111111)
    public static let elevated = Color(hex: 0x1A1A1A)
    public static let elevated2 = Color(hex: 0x222222)
    public static let border = Color(hex: 0x242424)
    public static let border2 = Color(hex: 0x2E2E2E)

    public static let brand = Color(hex: 0x0A84FF)
    public static let green = Color(hex: 0x30D158)
    public static let red = Color(hex: 0xFF453A)
    public static let gold = Color(hex: 0xFFB800)
    public static let orange = Color(hex: 0xFF9F0A)
    public static let purple = Color(hex: 0xBF5AF2)
    public static let teal = Color(hex: 0x4DD0E1)

    public static let textPrimary = Color.white
    public static let textSecondary = Color(hex: 0x8A8A8E)
    public static let textHint = Color(hex: 0x48484A)

    public static func difficulty(_ value: Difficulty) -> Color {
        switch value {
        case .beginner: return green
        case .intermediate: return orange
        case .advanced: return red
        case .elite: return purple
        case .unknown: return textSecondary
        }
    }
}
