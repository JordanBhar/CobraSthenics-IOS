import SwiftUI

public struct SettingsListHeader: View {
    public let title: String

    public init(_ title: String) { self.title = title }

    public var body: some View {
        Text(title.uppercased())
            .font(.appLabel)
            .foregroundStyle(AppColor.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xs)
    }
}

public struct SettingsListGroup<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }
}

public struct SettingsListRow<Trailing: View>: View {
    public let systemImage: String?
    public let iconColor: Color
    public let label: String
    public let sub: String?
    public let destructive: Bool
    public let showsDivider: Bool
    public let trailing: Trailing
    public let action: (() -> Void)?

    public init(
        systemImage: String? = nil,
        iconColor: Color = AppColor.brand,
        label: String,
        sub: String? = nil,
        destructive: Bool = false,
        showsDivider: Bool = true,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.systemImage = systemImage
        self.iconColor = iconColor
        self.label = label
        self.sub = sub
        self.destructive = destructive
        self.showsDivider = showsDivider
        self.trailing = trailing()
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: AppSpacing.sm) {
                    if let systemImage {
                        ZStack {
                            RoundedRectangle(cornerRadius: 9, style: .continuous)
                                .fill(iconColor.opacity(0.14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                                        .stroke(iconColor.opacity(0.3), lineWidth: 1)
                                )
                            Image(systemName: systemImage)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(iconColor)
                        }
                        .frame(width: 30, height: 30)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(label)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(destructive ? AppColor.red : AppColor.textPrimary)
                        if let sub {
                            Text(sub)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(AppColor.textSecondary)
                                .lineLimit(2)
                        }
                    }
                    Spacer(minLength: AppSpacing.sm)
                    trailing
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, 12)
                .frame(minHeight: 52)

                if showsDivider {
                    Rectangle()
                        .fill(AppColor.border)
                        .frame(height: 1)
                        .padding(.leading, 56)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

public extension SettingsListRow where Trailing == DisclosureChevron {
    init(
        systemImage: String? = nil,
        iconColor: Color = AppColor.brand,
        label: String,
        sub: String? = nil,
        destructive: Bool = false,
        showsDivider: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.init(
            systemImage: systemImage,
            iconColor: iconColor,
            label: label,
            sub: sub,
            destructive: destructive,
            showsDivider: showsDivider,
            action: action,
            trailing: { DisclosureChevron() }
        )
    }
}

public struct DisclosureChevron: View {
    public init() {}
    public var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(AppColor.textHint)
    }
}
