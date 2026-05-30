import SwiftUI

public struct FlowLayout: View {
    public let items: [String]
    public let color: Color
    public let outline: Bool

    public init(items: [String], color: Color, outline: Bool = false) {
        self.items = items
        self.color = color
        self.outline = outline
    }

    public var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.5)
                    .foregroundStyle(outline ? AppColor.textSecondary : color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(outline ? Color.white.opacity(0.06) : color.opacity(0.18))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(outline ? AppColor.border : color.opacity(0.3), lineWidth: 1))
            }
        }
    }
}
