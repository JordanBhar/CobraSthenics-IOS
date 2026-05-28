import SwiftUI

public extension Font {
    static let appDisplay = Font.system(size: 38, weight: .black, design: .default)
    static let appH1 = Font.system(size: 28, weight: .black, design: .default)
    static let appH2 = Font.system(size: 22, weight: .heavy, design: .default)
    static let appH3 = Font.system(size: 17, weight: .heavy, design: .default)
    static let appBodyLarge = Font.system(size: 15, weight: .semibold, design: .default)
    static let appBody = Font.system(size: 13, weight: .regular, design: .default)
    static let appLabel = Font.system(size: 11, weight: .bold, design: .default)
    static let appCaption = Font.system(size: 10, weight: .semibold, design: .default)
    static let appMono = Font.system(size: 13, weight: .medium, design: .monospaced)
    static let appMonoLarge = Font.system(size: 20, weight: .black, design: .monospaced)
}
