import SwiftUI

// MARK: - Help & FAQ

public struct HelpFAQView: View {
    @State private var expanded: Int? = 0
    @State private var searchText = ""

    private struct Entry: Identifiable {
        let id = UUID()
        let question: String
        let answer: String
    }

    private let entries: [Entry] = [
        .init(question: "How do I track a skill hold?",
              answer: "Go to Skills → tap the skill → Train Skill. The timer starts automatically when form is detected as good, and stops the moment your hold breaks. Each rep is logged to your session."),
        .init(question: "Why is my streak broken?",
              answer: "Your streak resets if you go a full calendar day without logging any workout or skill session. Add a 5-minute mobility flow before midnight to preserve it."),
        .init(question: "How does AI form analysis work?",
              answer: "Point your camera at yourself mid-hold and tap Analyse Form. On-device ML extracts your joint positions and compares them to ideal alignment for that skill — no video leaves your phone."),
        .init(question: "Can I use Cobrasthenics offline?",
              answer: "Yes — workouts, skill logs, and the full exercise library work without a connection. Sync resumes the next time you're online.")
    ]

    public init() {}

    public var body: some View {
        SettingsScreen(title: SettingsConstants.HelpFAQ.title) {
            SearchField(text: $searchText, placeholder: SettingsConstants.HelpFAQ.searchPlaceholder)
                .padding(.top, AppSpacing.md)

            SettingsListHeader(SettingsConstants.HelpFAQ.popularHeader)
            VStack(spacing: AppSpacing.xs) {
                ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                    faqRow(entry, index: index)
                }
            }

            SettingsListHeader(SettingsConstants.HelpFAQ.contactHeader)
            VStack(spacing: AppSpacing.xs) {
                contactCard(icon: "message.fill", color: AppColor.brand, title: SettingsConstants.HelpFAQ.chatTitle, sub: SettingsConstants.HelpFAQ.chatSub)
                contactCard(icon: "envelope.fill", color: AppColor.textSecondary, title: SettingsConstants.HelpFAQ.emailTitle, sub: SettingsConstants.HelpFAQ.emailSub)
            }
        }
    }

    private func faqRow(_ entry: Entry, index: Int) -> some View {
        let isOpen = expanded == index
        return Button {
            withAnimation(AppAnimation.standard) {
                expanded = isOpen ? nil : index
            }
        } label: {
            AppCard(padding: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 10) {
                        Text(entry.question)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(AppColor.textPrimary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(AppColor.textHint)
                            .rotationEffect(.degrees(isOpen ? 90 : 0))
                    }
                    if isOpen {
                        Rectangle().fill(AppColor.border).frame(height: 1)
                        Text(entry.answer)
                            .font(.appBody)
                            .foregroundStyle(AppColor.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func contactCard(icon: String, color: Color, title: String, sub: String) -> some View {
        AppCard(padding: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(color.opacity(0.14))
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(color)
                }
                .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                    Text(sub)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textHint)
            }
        }
    }
}

// MARK: - Send Feedback

public struct SendFeedbackView: View {
    @State private var type: String = "Feature request"
    @State private var subject = "Add custom skill goal cadence (weekly vs daily)"
    @State private var message = "Right now my Front Lever goal renews weekly, but I'd like a daily option for skills I'm grinding multiple times a day. Would also love to see the streak count on the goal card itself."
    @State private var stars = 4
    @State private var attachScreenshot = false

    public init() {}

    public var body: some View {
        SettingsScreen(title: SettingsConstants.Feedback.title, showsSaveCTA: true, ctaTitle: SettingsConstants.Feedback.ctaTitle) {
            SettingsListHeader(SettingsConstants.Feedback.typeHeader)
            FilterChips(
                options: SettingsConstants.Feedback.types,
                selected: type,
                label: { $0 },
                onSelect: { type = $0 }
            )

            VStack(spacing: AppSpacing.sm) {
                FieldCard(label: SettingsConstants.Feedback.subjectLabel, text: $subject)
                messageField
            }
            .padding(.top, AppSpacing.md)

            SettingsListGroup {
                SettingsListRow(
                    systemImage: "photo",
                    iconColor: AppColor.textSecondary,
                    label: SettingsConstants.Feedback.attachScreenshotLabel,
                    sub: SettingsConstants.Feedback.attachScreenshotSub,
                    showsDivider: false
                ) {
                    AppToggle(isOn: $attachScreenshot)
                }
            }

            SettingsListHeader(SettingsConstants.Feedback.satisfactionHeader)
            AppCard(padding: 16) {
                HStack(spacing: 12) {
                    Spacer()
                    ForEach(1...5, id: \.self) { value in
                        Button {
                            stars = value
                        } label: {
                            Image(systemName: value <= stars ? "star.fill" : "star")
                                .font(.system(size: 28))
                                .foregroundStyle(value <= stars ? AppColor.gold : AppColor.textHint)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
            }

            Text(SettingsConstants.Feedback.footer)
                .font(.appCaption)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.md)
        }
    }

    private var messageField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(SettingsConstants.Feedback.messageLabel)
                .font(.appLabel)
                .tracking(0.8)
                .foregroundStyle(AppColor.textSecondary)
            VStack {
                TextField("", text: $message, axis: .vertical)
                    .lineLimit(4...8)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColor.textPrimary)
                HStack {
                    Spacer()
                    Text(String(format: SettingsConstants.Feedback.messageCounterFormat, message.count))
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .tracking(0.4)
                        .foregroundStyle(AppColor.textHint)
                }
            }
            .padding(14)
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppColor.border, lineWidth: 1)
            )
        }
    }
}

// MARK: - Delete Account

public struct DeleteAccountView: View {
    @State private var typed = ""
    @Environment(\.dismiss) private var dismiss

    private var canDelete: Bool { typed == SettingsConstants.DeleteAccount.confirmKeyword }

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    warningCard
                    SettingsListHeader(SettingsConstants.DeleteAccount.willDeleteHeader)
                    deletionList
                    SettingsListHeader(SettingsConstants.DeleteAccount.beforeYouGoHeader)
                    beforeYouGo
                    SettingsListHeader(SettingsConstants.DeleteAccount.confirmHeader)
                    confirmInput
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, 140)
            }
            deleteCTA
        }
        .navigationTitle(SettingsConstants.DeleteAccount.title)
        .appNavigationBarTitleDisplayModeInline()
    }

    private var warningCard: some View {
        AppCard(background: AppColor.red.opacity(0.08), border: AppColor.red.opacity(0.3)) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(AppColor.red.opacity(0.18))
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(AppColor.red.opacity(0.35), lineWidth: 1)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(AppColor.red)
                }
                .frame(width: 40, height: 40)
                Text(SettingsConstants.DeleteAccount.warningTitle)
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundStyle(AppColor.textPrimary)
                Text(SettingsConstants.DeleteAccount.warningBody)
                    .font(.appBody)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
    }

    private var deletionList: some View {
        AppCard(background: AppColor.red.opacity(0.04), border: AppColor.red.opacity(0.18)) {
            VStack(alignment: .leading, spacing: 0) {
                let items = SettingsConstants.DeleteAccount.deletionItems
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(AppColor.red)
                            .padding(.top, 3)
                        Text(item)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AppColor.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 8)
                    if index < items.count - 1 {
                        Rectangle().fill(AppColor.red.opacity(0.12)).frame(height: 1)
                    }
                }
            }
        }
    }

    private var beforeYouGo: some View {
        VStack(spacing: AppSpacing.xs) {
            beforeYouGoCard(icon: SettingsConstants.DeleteAccount.exportIcon, title: SettingsConstants.DeleteAccount.exportTitle, sub: SettingsConstants.DeleteAccount.exportSub)
            beforeYouGoCard(icon: SettingsConstants.DeleteAccount.pauseIcon, title: SettingsConstants.DeleteAccount.pauseTitle, sub: SettingsConstants.DeleteAccount.pauseSub)
        }
    }

    private func beforeYouGoCard(icon: String, title: String, sub: String) -> some View {
        AppCard(padding: 14, background: AppColor.elevated) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(AppColor.brand.opacity(0.14))
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(AppColor.brand.opacity(0.3), lineWidth: 1)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.brand)
                }
                .frame(width: 36, height: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(title) →")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppColor.brand)
                    Text(sub)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private var confirmInput: some View {
        VStack(spacing: AppSpacing.xs) {
            HStack(spacing: 12) {
                TextField(SettingsConstants.DeleteAccount.confirmPlaceholder, text: $typed)
                    .font(.system(size: 17, weight: .bold, design: .monospaced))
                    .tracking(2.7)
                    .foregroundStyle(canDelete ? AppColor.red : AppColor.textPrimary)
                    .autocorrectionDisabled()
                    .appTextInputAutocapitalizationNever()
                if canDelete {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppColor.red)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(typed.isEmpty ? AppColor.border : AppColor.red, lineWidth: 1)
            )

            HStack(spacing: AppSpacing.xs) {
                smallChip(SettingsConstants.DeleteAccount.clearAction, accent: false) { typed = "" }
                smallChip(SettingsConstants.DeleteAccount.typeDeleteAction, accent: true) { typed = SettingsConstants.DeleteAccount.confirmKeyword }
                Spacer()
            }
        }
    }

    private func smallChip(_ label: String, accent: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .tracking(0.4)
                .foregroundStyle(accent ? AppColor.red : AppColor.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(accent ? AppColor.red.opacity(0.14) : Color.clear)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(accent ? AppColor.red.opacity(0.3) : AppColor.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var deleteCTA: some View {
        VStack(spacing: 12) {
            Button {} label: {
                Text(SettingsConstants.DeleteAccount.ctaTitle)
                    .font(.appBodyLarge)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColor.red.opacity(canDelete ? 1 : 0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(!canDelete)

            Button {
                dismiss()
            } label: {
                Text(SettingsConstants.DeleteAccount.goBack)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppColor.textSecondary)
            }
            .buttonStyle(.plain)
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

#Preview("Help & FAQ") {
    NavigationStack {
        HelpFAQView()
    }
}

#Preview("Send Feedback") {
    NavigationStack {
        SendFeedbackView()
    }
}

#Preview("Delete Account") {
    NavigationStack {
        DeleteAccountView()
    }
}
