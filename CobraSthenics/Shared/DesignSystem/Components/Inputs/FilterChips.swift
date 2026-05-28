import SwiftUI

public struct FilterChips<T: Hashable>: View {
    public let options: [T]
    public let selected: T
    public let label: (T) -> String
    public let onSelect: (T) -> Void

    public init(options: [T], selected: T, label: @escaping (T) -> String, onSelect: @escaping (T) -> Void) {
        self.options = options
        self.selected = selected
        self.label = label
        self.onSelect = onSelect
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.xs) {
                ForEach(options, id: \.self) { option in
                    let isSelected = option == selected
                    Button {
                        onSelect(option)
                    } label: {
                        Text(label(option))
                            .font(.appCaption)
                            .foregroundStyle(isSelected ? AppColor.background : AppColor.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(isSelected ? AppColor.brand : AppColor.elevated)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(isSelected ? AppColor.brand : AppColor.border, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
