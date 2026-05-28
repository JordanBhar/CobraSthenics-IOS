import SwiftUI

// MARK: - Edit Profile

public struct EditProfileView: View {
    @State private var displayName = "Jordan Bhar"
    @State private var username = "@ObsidianCobra"
    @State private var bio = "Rings obsessed. Chasing planche and iron cross."
    @State private var location = "Toronto, Canada"
    @State private var showPublic = true
    @State private var showActivity = false

    public init() {}

    public var body: some View {
        SettingsScreen(
            title: "Edit Profile",
            rightAction: AnyView(
                Button("Save") {}
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(AppColor.brand)
            ),
            showsSaveCTA: true,
            ctaTitle: "Save Changes"
        ) {
            avatarSection
                .padding(.top, AppSpacing.lg)
                .frame(maxWidth: .infinity)

            VStack(spacing: AppSpacing.sm) {
                FieldCard(label: "Display name", text: $displayName)
                FieldCard(label: "Username", text: $username)
                FieldCard(label: "Bio", text: $bio, multiline: true)
                FieldCard(label: "Location", text: $location, trailingSystemImage: "mappin.and.ellipse")
            }
            .padding(.top, AppSpacing.lg)

            SettingsListHeader("Public profile")
            SettingsListGroup {
                SettingsListRow(
                    systemImage: "globe",
                    iconColor: AppColor.brand,
                    label: "Show profile publicly",
                    sub: "Anyone can view your stats and achievements"
                ) {
                    AppToggle(isOn: $showPublic)
                }
                SettingsListRow(
                    systemImage: "waveform.path.ecg",
                    iconColor: AppColor.brand,
                    label: "Show workout activity",
                    sub: "Display recent sessions on your profile",
                    showsDivider: false
                ) {
                    AppToggle(isOn: $showActivity)
                }
            }
        }
    }

    private var avatarSection: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: 0x001D42), Color(hex: 0x003E8A)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Circle()
                    .stroke(AppColor.brand.opacity(0.4), lineWidth: 1)
                Text("JB")
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)
                ZStack {
                    Circle().fill(AppColor.brand)
                    Circle().stroke(AppColor.background, lineWidth: 2)
                    Image(systemName: "camera.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.white)
                }
                .frame(width: 26, height: 26)
                .offset(x: 28, y: 28)
            }
            .frame(width: 80, height: 80)
            Text("Change photo")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AppColor.brand)
        }
    }
}

// MARK: - Change Password

public struct ChangePasswordView: View {
    @State private var currentPassword = "MySecurePassword!23"
    @State private var newPassword = "NewPassword!2026"
    @State private var confirmPassword = "NewPassword!2026"
    @State private var showCurrent = false
    @State private var showNew = false
    @State private var showConfirm = false

    private let requirements: [(ok: Bool, text: String)] = [
        (true, "8+ characters"),
        (true, "Uppercase letter"),
        (true, "Number or symbol"),
        (false, "Not same as last password")
    ]
    private let strength = 3

    public init() {}

    public var body: some View {
        SettingsScreen(title: "Change Password", showsSaveCTA: true, ctaTitle: "Update Password") {
            Text("Choose a strong password you don't use anywhere else. You'll be signed out of all other devices.")
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)

            VStack(spacing: AppSpacing.sm) {
                passwordField("Current password", text: $currentPassword, reveal: $showCurrent)
                passwordField("New password", text: $newPassword, reveal: $showNew)
                strengthMeter
                passwordField("Confirm new password", text: $confirmPassword, reveal: $showConfirm)
            }
            .padding(.top, AppSpacing.md)

            requirementsCard
        }
    }

    private func passwordField(_ label: String, text: Binding<String>, reveal: Binding<Bool>) -> some View {
        FieldCard(
            label: label,
            text: text,
            secure: !reveal.wrappedValue,
            trailing: AnyView(
                Button {
                    reveal.wrappedValue.toggle()
                } label: {
                    Image(systemName: reveal.wrappedValue ? "eye.slash" : "eye")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.textHint)
                }
                .buttonStyle(.plain)
            )
        )
    }

    private var strengthMeter: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                ForEach(0..<4) { index in
                    Capsule()
                        .fill(index < strength ? AppColor.green : Color.white.opacity(0.06))
                        .frame(height: 4)
                }
            }
            Text("STRONG")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .tracking(0.8)
                .foregroundStyle(AppColor.green)
        }
    }

    private var requirementsCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                ForEach(Array(requirements.enumerated()), id: \.offset) { _, req in
                    HStack(spacing: 8) {
                        Image(systemName: req.ok ? "checkmark" : "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(req.ok ? AppColor.green : AppColor.red)
                        Text(req.text)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(req.ok ? AppColor.textPrimary : AppColor.red)
                    }
                }
            }
        }
    }
}

// MARK: - Connected Apps

public struct ConnectedAppsView: View {
    @State private var appleHealthOn = true
    @State private var googleFitOn = true

    public init() {}

    public var body: some View {
        SettingsScreen(title: "Connected Apps") {
            Text("Sync workouts and health data with your favourite health platforms.")
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)

            SettingsListHeader("Connected (2)")
            VStack(spacing: AppSpacing.sm) {
                connectedAppCard(
                    name: "Apple Health",
                    sub: "Syncing workouts, active energy, heart rate",
                    accent: AppColor.red,
                    iconSystem: "heart.fill",
                    iconBackground: Color.white,
                    connected: true,
                    binding: $appleHealthOn
                )
                connectedAppCard(
                    name: "Google Fit",
                    sub: "Syncing workout duration and calories",
                    accent: AppColor.brand,
                    iconSystem: "figure.run",
                    iconBackground: Color.white,
                    connected: true,
                    binding: $googleFitOn
                )
            }

            SettingsListHeader("Available")
            VStack(spacing: AppSpacing.sm) {
                connectedAppCard(
                    name: "Garmin Connect",
                    sub: "Not connected",
                    accent: AppColor.teal,
                    iconSystem: "applewatch",
                    iconBackground: Color(hex: 0x0099D5).opacity(0.5),
                    connected: false,
                    binding: .constant(false)
                )
                connectedAppCard(
                    name: "Strava",
                    sub: "Share workouts automatically",
                    accent: AppColor.orange,
                    iconSystem: "figure.outdoor.cycle",
                    iconBackground: Color(hex: 0xFC4C02).opacity(0.5),
                    connected: false,
                    binding: .constant(false)
                )
            }
        }
    }

    private func connectedAppCard(
        name: String,
        sub: String,
        accent: Color,
        iconSystem: String,
        iconBackground: Color,
        connected: Bool,
        binding: Binding<Bool>
    ) -> some View {
        AppCard(padding: 14) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(iconBackground)
                        Image(systemName: iconSystem)
                            .font(.system(size: 22))
                            .foregroundStyle(accent)
                    }
                    .frame(width: 44, height: 44)

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(AppColor.textPrimary)
                            if connected {
                                Text("CONNECTED")
                                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                                    .tracking(0.8)
                                    .foregroundStyle(AppColor.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(AppColor.green.opacity(0.14))
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(AppColor.green.opacity(0.3), lineWidth: 1))
                            }
                        }
                        Text(sub)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppColor.textSecondary)
                    }
                    Spacer(minLength: 0)
                    if connected {
                        AppToggle(isOn: binding)
                    } else {
                        Text("Connect")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.4)
                            .foregroundStyle(AppColor.brand)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(AppColor.brand.opacity(0.14))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(AppColor.brand.opacity(0.32), lineWidth: 1))
                    }
                }
                if connected {
                    Rectangle().fill(AppColor.border).frame(height: 1)
                    HStack {
                        Text("Manage permissions ›")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(AppColor.brand)
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Export Data

public struct ExportDataView: View {
    @State private var format: String = "JSON"
    @State private var range: String = "All time"
    @State private var includeWorkouts = true
    @State private var includeSkills = true
    @State private var includePRs = true
    @State private var includeBody = true
    @State private var includeChat = false
    @State private var includeSettings = false

    public init() {}

    public var body: some View {
        SettingsScreen(title: "Export Data", showsSaveCTA: true, ctaTitle: "Request Export") {
            Text("Download a complete copy of your Cobrasthenics data. Includes all workouts, skill logs, PRs, and settings.")
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)

            SettingsListHeader("Format")
            FilterChips(
                options: ["JSON", "CSV", "PDF Report"],
                selected: format,
                label: { $0 },
                onSelect: { format = $0 }
            )

            SettingsListHeader("Include")
            SettingsListGroup {
                checkRow("Workout history", "All sessions, sets, reps, holds", $includeWorkouts)
                checkRow("Skill progression logs", "Hold times, tier changes", $includeSkills)
                checkRow("Personal records", "All-time bests with dates", $includePRs)
                checkRow("Body measurements", "Weight, body fat, circumferences", $includeBody)
                checkRow("Chat / AI coach history", "Coach conversations and form reviews", $includeChat)
                checkRow("App settings", "Preferences and notification toggles", $includeSettings, showsDivider: false)
            }

            SettingsListHeader("Date range")
            FilterChips(
                options: ["Last 30 days", "Last 90 days", "This year", "All time"],
                selected: range,
                label: { $0 },
                onSelect: { range = $0 }
            )

            AppCard(background: AppColor.brand.opacity(0.08), border: AppColor.brand.opacity(0.25)) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.brand)
                    Group {
                        Text("Your export will be ready within a few minutes and sent to ")
                            .foregroundStyle(AppColor.textPrimary)
                    }
                    .font(.system(size: 12, weight: .medium))
                }
            }
            .padding(.top, AppSpacing.md)
        }
    }

    private func checkRow(_ label: String, _ sub: String, _ binding: Binding<Bool>, showsDivider: Bool = true) -> some View {
        SettingsListRow(
            label: label,
            sub: sub,
            showsDivider: showsDivider,
            action: { binding.wrappedValue.toggle() }
        ) {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(binding.wrappedValue ? AppColor.brand : Color.clear)
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(binding.wrappedValue ? AppColor.brand : AppColor.textHint, lineWidth: 1.5)
                if binding.wrappedValue {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 22, height: 22)
        }
    }
}

// MARK: - Field Card (used by Edit Profile + Change Password)

struct FieldCard: View {
    let label: String
    @Binding var text: String
    let multiline: Bool
    let secure: Bool
    let trailing: AnyView?
    let trailingSystemImage: String?

    init(
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

    var body: some View {
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

#Preview("Edit Profile") {
    NavigationStack {
        EditProfileView()
    }
}

#Preview("Change Password") {
    NavigationStack {
        ChangePasswordView()
    }
}

#Preview("Connected Apps") {
    NavigationStack {
        ConnectedAppsView()
    }
}

#Preview("Export Data") {
    NavigationStack {
        ExportDataView()
    }
}
