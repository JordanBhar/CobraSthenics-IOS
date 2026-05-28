import SwiftUI

public struct GradientCard<Content: View>: View {
    private let colors: [Color]
    private let accent: Color
    private let radius: CGFloat
    private let padding: CGFloat
    private let content: Content

    public init(
        colors: [Color],
        accent: Color,
        radius: CGFloat = AppRadius.lg,
        padding: CGFloat = AppSpacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.colors = colors
        self.accent = accent
        self.radius = radius
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(accent.opacity(0.22), lineWidth: 1)
            )
    }
}
