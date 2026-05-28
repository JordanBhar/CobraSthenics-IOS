import SwiftUI

public struct AppHeader: View {
    public let eyebrow: String
    public let title: String
    public let subtitle: String?
    public let trailing: AnyView?

    public init(eyebrow: String, title: String, subtitle: String? = nil, trailing: AnyView? = nil) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(eyebrow)
                    .font(.appLabel)
                    .foregroundStyle(AppColor.textSecondary)
                Text(title)
                    .font(.appH1)
                    .foregroundStyle(AppColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.appBody)
                        .foregroundStyle(AppColor.textSecondary)
                        .padding(.top, 2)
                }
            }
            Spacer(minLength: 0)
            if let trailing { trailing }
        }
    }
}

public struct AppNavBar: View {
    public let title: String
    public let rightAction: AnyView?
    public let onBack: () -> Void

    public init(title: String, rightAction: AnyView? = nil, onBack: @escaping () -> Void) {
        self.title = title
        self.rightAction = rightAction
        self.onBack = onBack
    }

    public var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AppColor.textPrimary)
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AppColor.brand)
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Spacer()
                if let rightAction { rightAction } else { Color.clear.frame(width: 36) }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 48)
        .background(AppColor.background)
        .overlay(Rectangle().fill(AppColor.border).frame(height: 1), alignment: .bottom)
    }
}
