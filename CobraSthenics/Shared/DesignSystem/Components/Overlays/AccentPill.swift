import SwiftUI

public struct AccentPill: View {
    public let title: String
    public let color: Color

    public init(_ title: String, color: Color) {
        self.title = title
        self.color = color
    }

    public var body: some View {
        Text(title.uppercased())
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .foregroundStyle(color)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(color.opacity(0.16))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(color.opacity(0.32), lineWidth: 1)
            )
    }
}
