import SwiftUI

public struct AppCard<Content: View>: View {
    private let radius: CGFloat
    private let padding: CGFloat
    private let background: Color
    private let border: Color
    private let content: Content

    public init(
        radius: CGFloat = AppRadius.md,
        padding: CGFloat = AppSpacing.md,
        background: Color = AppColor.card,
        border: Color = AppColor.border,
        @ViewBuilder content: () -> Content
    ) {
        self.radius = radius
        self.padding = padding
        self.background = background
        self.border = border
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(border, lineWidth: 1)
            )
    }
}
