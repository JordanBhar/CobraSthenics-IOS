import SwiftUI

public struct MiniBarChart: View {
    public let values: [Double]
    public let color: Color
    public let height: CGFloat

    public init(values: [Double], color: Color, height: CGFloat = 56) {
        self.values = values
        self.color = color
        self.height = height
    }

    public var body: some View {
        let maxValue = max(values.max() ?? 1, 1)
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(Array(values.enumerated()), id: \.offset) { _, value in
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color.opacity(0.35 + 0.65 * (value / maxValue)))
                    .frame(height: max(6, height * value / maxValue))
            }
        }
        .frame(height: height, alignment: .bottom)
    }
}
