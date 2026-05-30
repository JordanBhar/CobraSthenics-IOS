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
            title: SettingsConstants.EditProfile.title,
            rightAction: AnyView(
                Button(SettingsConstants.EditProfile.saveButton) {}
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(AppColor.brand)
            ),
            showsSaveCTA: true,
            ctaTitle: SettingsConstants.EditProfile.saveCTA
        ) {
            avatarSection
                .padding(.top, AppSpacing.lg)
                .frame(maxWidth: .infinity)

            VStack(spacing: AppSpacing.sm) {
                FieldCard(label: SettingsConstants.EditProfile.displayNameLabel, text: $displayName)
                FieldCard(label: SettingsConstants.EditProfile.usernameLabel, text: $username)
                FieldCard(label: SettingsConstants.EditProfile.bioLabel, text: $bio, multiline: true)
                FieldCard(label: SettingsConstants.EditProfile.locationLabel, text: $location, trailingSystemImage: SettingsConstants.EditProfile.locationIcon)
            }
            .padding(.top, AppSpacing.lg)

            SettingsListHeader(SettingsConstants.EditProfile.publicProfileHeader)
            SettingsListGroup {
                SettingsListRow(
                    systemImage: SettingsConstants.EditProfile.publicIcon,
                    iconColor: AppColor.brand,
                    label: SettingsConstants.EditProfile.showPublicLabel,
                    sub: SettingsConstants.EditProfile.showPublicSub
                ) {
                    AppToggle(isOn: $showPublic)
                }
                SettingsListRow(
                    systemImage: SettingsConstants.EditProfile.activityIcon,
                    iconColor: AppColor.brand,
                    label: SettingsConstants.EditProfile.showActivityLabel,
                    sub: SettingsConstants.EditProfile.showActivitySub,
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
            Text(SettingsConstants.EditProfile.changePhoto)
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
        (true, SettingsConstants.ChangePassword.requirementMinLength),
        (true, SettingsConstants.ChangePassword.requirementUppercase),
        (true, SettingsConstants.ChangePassword.requirementNumberSymbol),
        (false, SettingsConstants.ChangePassword.requirementNotReused)
    ]
    private let strength = 3

    public init() {}

    public var body: some View {
        SettingsScreen(title: SettingsConstants.ChangePassword.title, showsSaveCTA: true, ctaTitle: SettingsConstants.ChangePassword.ctaTitle) {
            Text(SettingsConstants.ChangePassword.intro)
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)

            VStack(spacing: AppSpacing.sm) {
                passwordField(SettingsConstants.ChangePassword.currentPasswordLabel, text: $currentPassword, reveal: $showCurrent)
                passwordField(SettingsConstants.ChangePassword.newPasswordLabel, text: $newPassword, reveal: $showNew)
                strengthMeter
                passwordField(SettingsConstants.ChangePassword.confirmPasswordLabel, text: $confirmPassword, reveal: $showConfirm)
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
                    Image(systemName: reveal.wrappedValue ? SettingsConstants.ChangePassword.eyeClosed : SettingsConstants.ChangePassword.eyeOpen)
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
            Text(SettingsConstants.ChangePassword.strengthStrong)
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
        SettingsScreen(title: SettingsConstants.ConnectedApps.title) {
            Text(SettingsConstants.ConnectedApps.intro)
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)

            SettingsListHeader(SettingsConstants.ConnectedApps.connectedHeader)
            VStack(spacing: AppSpacing.sm) {
                connectedAppCard(
                    name: SettingsConstants.ConnectedApps.appleHealthName,
                    sub: SettingsConstants.ConnectedApps.appleHealthSub,
                    accent: AppColor.red,
                    iconSystem: "heart.fill",
                    iconBackground: Color.white,
                    connected: true,
                    binding: $appleHealthOn
                )
                connectedAppCard(
                    name: SettingsConstants.ConnectedApps.googleFitName,
                    sub: SettingsConstants.ConnectedApps.googleFitSub,
                    accent: AppColor.brand,
                    iconSystem: "figure.run",
                    iconBackground: Color.white,
                    connected: true,
                    binding: $googleFitOn
                )
            }

            SettingsListHeader(SettingsConstants.ConnectedApps.availableHeader)
            VStack(spacing: AppSpacing.sm) {
                connectedAppCard(
                    name: SettingsConstants.ConnectedApps.garminName,
                    sub: SettingsConstants.ConnectedApps.garminSub,
                    accent: AppColor.teal,
                    iconSystem: "applewatch",
                    iconBackground: Color(hex: 0x0099D5).opacity(0.5),
                    connected: false,
                    binding: .constant(false)
                )
                connectedAppCard(
                    name: SettingsConstants.ConnectedApps.stravaName,
                    sub: SettingsConstants.ConnectedApps.stravaSub,
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
                                Text(SettingsConstants.ConnectedApps.connectedBadge)
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
                        Text(SettingsConstants.ConnectedApps.connectButton)
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
                        Text(SettingsConstants.ConnectedApps.managePermissions)
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
        SettingsScreen(title: SettingsConstants.ExportData.title, showsSaveCTA: true, ctaTitle: SettingsConstants.ExportData.ctaTitle) {
            Text(SettingsConstants.ExportData.intro)
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)

            SettingsListHeader(SettingsConstants.ExportData.formatHeader)
            FilterChips(
                options: SettingsConstants.ExportData.formats,
                selected: format,
                label: { $0 },
                onSelect: { format = $0 }
            )

            SettingsListHeader(SettingsConstants.ExportData.includeHeader)
            SettingsListGroup {
                checkRow(SettingsConstants.ExportData.workoutsLabel, SettingsConstants.ExportData.workoutsSub, $includeWorkouts)
                checkRow(SettingsConstants.ExportData.skillsLabel, SettingsConstants.ExportData.skillsSub, $includeSkills)
                checkRow(SettingsConstants.ExportData.prsLabel, SettingsConstants.ExportData.prsSub, $includePRs)
                checkRow(SettingsConstants.ExportData.bodyLabel, SettingsConstants.ExportData.bodySub, $includeBody)
                checkRow(SettingsConstants.ExportData.chatLabel, SettingsConstants.ExportData.chatSub, $includeChat)
                checkRow(SettingsConstants.ExportData.settingsLabel, SettingsConstants.ExportData.settingsSub, $includeSettings, showsDivider: false)
            }

            SettingsListHeader(SettingsConstants.ExportData.dateRangeHeader)
            FilterChips(
                options: SettingsConstants.ExportData.ranges,
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
                        Text(SettingsConstants.ExportData.exportReadyInfo)
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
