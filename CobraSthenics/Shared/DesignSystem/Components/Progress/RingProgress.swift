import SwiftUI

public struct RingProgress: View {
    public let progress: Double
    public let color: Color
    public let size: CGFloat
    public let label: String

    public init(progress: Double, color: Color, size: CGFloat = 50, label: String) {
        self.progress = min(max(progress, 0), 1)
        self.color = color
        self.size = size
        self.label = label
    }

    public var body: some View {
        ZStack {
            Circle().stroke(color.opacity(0.2), lineWidth: 5)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(label)
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(color)
        }
        .frame(width: size, height: size)
    }
}
