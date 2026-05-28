import SwiftUI

public struct AppProgressBar: View {
    public let progress: Double
    public let color: Color
    public let height: CGFloat

    public init(progress: Double, color: Color, height: CGFloat = 7) {
        self.progress = min(max(progress, 0), 1)
        self.color = color
        self.height = height
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(AppColor.elevated)
                Capsule()
                    .fill(color)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: height)
    }
}
