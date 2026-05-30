import SwiftUI

public struct FieldCard: View {
    public let label: String
    @Binding public var text: String
    public let multiline: Bool
    public let secure: Bool
    public let trailing: AnyView?
    public let trailingSystemImage: String?

    public init(
        label: String,
        text: Binding<String>,
        multiline: Bool = false,
        secure: Bool = false,
        trailing: AnyView? = nil,
        trailingSystemImage: String? = nil
    ) {
        self.label = label
        self._text = text
        self.multiline = multiline
        self.secure = secure
        self.trailing = trailing
        self.trailingSystemImage = trailingSystemImage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label.uppercased())
                .font(.appLabel)
                .tracking(0.8)
                .foregroundStyle(AppColor.textSecondary)
            HStack(spacing: 12) {
                Group {
                    if multiline {
                        TextField("", text: $text, axis: .vertical)
                            .lineLimit(3...5)
                    } else if secure {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppColor.textPrimary)
                .appTextInputAutocapitalizationNever()
                .autocorrectionDisabled()
                if let trailing { trailing }
                else if let trailingSystemImage {
                    Image(systemName: trailingSystemImage)
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.textHint)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, multiline ? 14 : 0)
            .frame(minHeight: multiline ? 90 : 50, alignment: multiline ? .topLeading : .center)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppColor.border, lineWidth: 1)
            )
        }
    }
}
