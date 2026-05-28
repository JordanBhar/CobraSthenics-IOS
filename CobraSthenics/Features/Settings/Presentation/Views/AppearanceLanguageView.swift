import SwiftUI

public struct AppearanceSettingsView: View {
    @State private var selected: String = "Dark"

    private struct ThemeOption: Identifiable {
        let id: String
        let label: String
        let sub: String
        let available: Bool
        let isLight: Bool
        let isMixed: Bool
    }

    private let options: [ThemeOption] = [
        ThemeOption(id: "Dark", label: "Dark", sub: "The default Cobrasthenics experience", available: true, isLight: false, isMixed: false),
        ThemeOption(id: "Light", label: "Light", sub: "High contrast light mode", available: false, isLight: true, isMixed: false),
        ThemeOption(id: "System", label: "Match system", sub: "Follows your iOS appearance setting", available: false, isLight: false, isMixed: true)
    ]

    public init() {}

    public var body: some View {
        SettingsScreen(title: "Appearance") {
            VStack(spacing: AppSpacing.sm) {
                ForEach(options) { option in
                    themeOptionRow(option)
                }
            }
            .padding(.top, AppSpacing.md)
            Text("Cobrasthenics is a dark-first experience. Additional themes are in development.")
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.lg)
        }
    }

    private func themeOptionRow(_ option: ThemeOption) -> some View {
        Button {
            if option.available { selected = option.id }
        } label: {
            HStack(spacing: AppSpacing.md) {
                themePreview(option)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(option.label)
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundStyle(AppColor.textPrimary)
                        if !option.available {
                            Text("COMING SOON")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .tracking(0.8)
                                .foregroundStyle(AppColor.textHint)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.06))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(AppColor.border, lineWidth: 1))
                        }
                    }
                    Text(option.sub)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer(minLength: 0)
                if selected == option.id {
                    ZStack {
                        Circle().fill(AppColor.brand)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 24, height: 24)
                } else if !option.available {
                    Image(systemName: "lock")
                        .font(.system(size: 13))
                        .foregroundStyle(AppColor.textHint)
                }
            }
            .padding(16)
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(selected == option.id ? AppColor.brand : AppColor.border, lineWidth: 1)
            )
            .opacity(option.available ? 1 : 0.6)
        }
        .buttonStyle(.plain)
    }

    private func themePreview(_ option: ThemeOption) -> some View {
        ZStack(alignment: .topLeading) {
            if option.isMixed {
                LinearGradient(colors: [Color(hex: 0x080808), Color(hex: 0xF2F2F7)], startPoint: .topLeading, endPoint: .bottomTrailing)
            } else if option.isLight {
                Color(hex: 0xF2F2F7)
            } else {
                Color(hex: 0x080808)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Capsule().fill((option.isLight ? Color.black : Color.white).opacity(0.7)).frame(width: 14, height: 5)
                    Spacer()
                    Capsule().fill((option.isLight ? Color.black : Color.white).opacity(0.5)).frame(width: 10, height: 5)
                }
                Rectangle()
                    .fill(option.isMixed ? AppColor.brand.opacity(0.3) : (option.isLight ? Color(hex: 0xE5E5EA) : AppColor.elevated))
                    .frame(height: 18)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                Rectangle()
                    .fill(AppColor.brand.opacity(option.isLight ? 0.85 : 1))
                    .frame(height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                Spacer()
                Rectangle()
                    .fill(option.isLight ? Color(hex: 0xE5E5EA) : AppColor.elevated)
                    .frame(height: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            }
            .padding(8)
        }
        .frame(width: 64, height: 96)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppColor.border2, lineWidth: 1)
        )
    }
}

public struct LanguageSettingsView: View {
    private struct Language: Identifiable {
        let id: String
        let name: String
        let region: String?
        let native: String
    }

    @State private var selected = "en-US"
    @State private var searchText = ""

    private let languages: [Language] = [
        .init(id: "en-US", name: "English", region: "United States", native: "English (US)"),
        .init(id: "en-UK", name: "English", region: "United Kingdom", native: "English (UK)"),
        .init(id: "fr", name: "French", region: nil, native: "Français"),
        .init(id: "de", name: "German", region: nil, native: "Deutsch"),
        .init(id: "es", name: "Spanish", region: nil, native: "Español"),
        .init(id: "pt", name: "Portuguese", region: nil, native: "Português"),
        .init(id: "it", name: "Italian", region: nil, native: "Italiano"),
        .init(id: "ja", name: "Japanese", region: nil, native: "日本語"),
        .init(id: "ko", name: "Korean", region: nil, native: "한국어"),
        .init(id: "zh", name: "Chinese", region: "Simplified", native: "中文 (简体)")
    ]

    public init() {}

    public var body: some View {
        SettingsScreen(title: "Language") {
            SearchField(text: $searchText, placeholder: "Search languages…")
                .padding(.top, AppSpacing.md)

            SettingsListHeader("Current")
            SettingsListGroup {
                SettingsListRow(
                    label: "English (US)",
                    sub: "English",
                    showsDivider: false
                ) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppColor.brand)
                }
            }

            SettingsListHeader("All languages")
            SettingsListGroup {
                ForEach(Array(filtered.enumerated()), id: \.element.id) { index, language in
                    SettingsListRow(
                        label: language.native,
                        sub: language.region.map { "\(language.name) · \($0)" } ?? language.name,
                        showsDivider: index < filtered.count - 1,
                        action: { selected = language.id }
                    ) {
                        if selected == language.id {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(AppColor.brand)
                        }
                    }
                }
            }

            Text("Changing language restarts the app.")
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.lg)
        }
    }

    private var filtered: [Language] {
        guard !searchText.isEmpty else { return languages }
        return languages.filter {
            $0.native.localizedCaseInsensitiveContains(searchText) ||
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview("Appearance") {
    NavigationStack {
        AppearanceSettingsView()
    }
}

#Preview("Language") {
    NavigationStack {
        LanguageSettingsView()
    }
}
