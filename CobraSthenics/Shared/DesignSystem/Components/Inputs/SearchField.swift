import SwiftUI

public struct SearchField: View {
    @Binding public var text: String
    public let placeholder: String

    public init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColor.textHint)
            TextField(placeholder, text: $text)
                .appTextInputAutocapitalizationNever()
                .autocorrectionDisabled()
                .font(.appBody)
                .foregroundStyle(AppColor.textPrimary)
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(AppColor.elevated)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }
}
