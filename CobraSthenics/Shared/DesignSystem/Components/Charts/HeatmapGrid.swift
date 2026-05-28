import SwiftUI

public struct HeatmapGrid: View {
    public let grid: [[Int]]
    public let color: Color

    public init(grid: [[Int]], color: Color) {
        self.grid = grid
        self.color = color
    }

    public var body: some View {
        VStack(spacing: 6) {
            ForEach(Array(grid.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 6) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, value in
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(value == 0 ? AppColor.elevated : color.opacity(0.25 + Double(value) * 0.2))
                            .frame(height: 18)
                    }
                }
            }
        }
    }
}
