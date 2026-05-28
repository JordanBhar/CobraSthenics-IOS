import SwiftUI

public struct SectionHeader: View {
    public let title: String
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(_ title: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.appH3)
                .foregroundStyle(AppColor.textPrimary)
            Spacer()
            if let actionTitle {
                Button(actionTitle, action: action ?? {})
                    .font(.appCaption)
                    .foregroundStyle(AppColor.brand)
            }
        }
    }
}
