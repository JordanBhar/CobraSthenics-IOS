import SwiftUI

public struct TierDots: View {
    public let current: Int
    public let total: Int
    public let accent: Color
    public let height: CGFloat

    public init(current: Int, total: Int, accent: Color, height: CGFloat = 5) {
        self.current = current
        self.total = total
        self.accent = accent
        self.height = height
    }

    public var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index < current ? accent : Color.white.opacity(0.06))
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
