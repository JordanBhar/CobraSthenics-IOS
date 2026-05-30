import SwiftUI

public struct SettingsScreen<Content: View>: View {
    public let title: String
    public let rightAction: AnyView?
    public let showsSaveCTA: Bool
    public let ctaTitle: String
    public let ctaAction: () -> Void
    public let content: Content

    public init(
        title: String,
        rightAction: AnyView? = nil,
        showsSaveCTA: Bool = false,
        ctaTitle: String = "Save",
        ctaAction: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.rightAction = rightAction
        self.showsSaveCTA = showsSaveCTA
        self.ctaTitle = ctaTitle
        self.ctaAction = ctaAction
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    content
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, showsSaveCTA ? 130 : AppSpacing.xxl)
            }
            if showsSaveCTA {
                VStack {
                    PrimaryButton(ctaTitle, action: ctaAction)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.lg)
                .background(
                    LinearGradient(
                        colors: [AppColor.background.opacity(0), AppColor.background],
                        startPoint: .top, endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            }
        }
        .navigationTitle(title)
        .appNavigationBarTitleDisplayModeInline()
        .toolbar {
            if let rightAction {
                ToolbarItem(placement: .topBarTrailing) { rightAction }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen(title: "Settings Preview", showsSaveCTA: true) {
            Text("Settings content goes here")
                .font(.appBody)
                .foregroundStyle(AppColor.textPrimary)
                .padding()
        }
    }
}
