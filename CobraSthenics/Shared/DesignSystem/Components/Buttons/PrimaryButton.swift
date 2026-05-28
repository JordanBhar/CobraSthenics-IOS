import SwiftUI

public struct PrimaryButton: View {
    public let title: String
    public let systemImage: String?
    public let color: Color
    public let action: () -> Void

    public init(_ title: String, systemImage: String? = nil, color: Color = AppColor.brand, action: @escaping () -> Void = {}) {
        self.title = title
        self.systemImage = systemImage
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.appBodyLarge)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
