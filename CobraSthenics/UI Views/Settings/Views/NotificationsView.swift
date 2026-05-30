import SwiftUI

public struct NotificationsSettingsView: View {
    @State private var sessionReminders = true
    @State private var restTimerAlerts = true
    @State private var workoutSummary = true
    @State private var prAchieved = true
    @State private var tierUnlocked = true
    @State private var coachGoals = true
    @State private var weeklyPlan = true
    @State private var recoverySuggestions = false
    @State private var formAnalysis = true
    @State private var newFollowers = false
    @State private var postReactions = false
    @State private var mentions = true

    public init() {}

    public var body: some View {
        SettingsScreen(title: SettingsConstants.Notifications.title) {
            Text(SettingsConstants.Notifications.intro)
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)

            SettingsListHeader(SettingsConstants.Notifications.workoutsHeader)
            SettingsListGroup {
                toggleRow("bell", AppColor.brand, SettingsConstants.Notifications.sessionRemindersLabel, SettingsConstants.Notifications.sessionRemindersSub, $sessionReminders)
                toggleRow("timer", AppColor.brand, SettingsConstants.Notifications.restTimerLabel, SettingsConstants.Notifications.restTimerSub, $restTimerAlerts)
                toggleRow("checkmark.circle", AppColor.brand, SettingsConstants.Notifications.workoutSummaryLabel, SettingsConstants.Notifications.workoutSummarySub, $workoutSummary, showsDivider: false)
            }

            SettingsListHeader(SettingsConstants.Notifications.skillsHeader)
            SettingsListGroup {
                toggleRow("trophy", AppColor.gold, SettingsConstants.Notifications.prAchievedLabel, SettingsConstants.Notifications.prAchievedSub, $prAchieved)
                toggleRow("chart.line.uptrend.xyaxis", AppColor.green, SettingsConstants.Notifications.tierUnlockedLabel, SettingsConstants.Notifications.tierUnlockedSub, $tierUnlocked)
                toggleRow("target", AppColor.green, SettingsConstants.Notifications.coachGoalsLabel, SettingsConstants.Notifications.coachGoalsSub, $coachGoals, showsDivider: false)
            }

            SettingsListHeader(SettingsConstants.Notifications.coachHeader)
            SettingsListGroup {
                toggleRow("calendar.badge.clock", AppColor.purple, SettingsConstants.Notifications.weeklyPlanLabel, SettingsConstants.Notifications.weeklyPlanSub, $weeklyPlan)
                toggleRow("moon.fill", AppColor.purple, SettingsConstants.Notifications.recoveryLabel, SettingsConstants.Notifications.recoverySub, $recoverySuggestions)
                toggleRow("camera.fill", AppColor.purple, SettingsConstants.Notifications.formAnalysisLabel, SettingsConstants.Notifications.formAnalysisSub, $formAnalysis, showsDivider: false)
            }

            SettingsListHeader(SettingsConstants.Notifications.socialHeader)
            SettingsListGroup {
                toggleRow("person.fill.badge.plus", AppColor.orange, SettingsConstants.Notifications.newFollowersLabel, nil, $newFollowers)
                toggleRow("heart", AppColor.orange, SettingsConstants.Notifications.postReactionsLabel, nil, $postReactions)
                toggleRow("at", AppColor.orange, SettingsConstants.Notifications.mentionsLabel, SettingsConstants.Notifications.mentionsSub, $mentions, showsDivider: false)
            }

            Text(SettingsConstants.Notifications.footer)
                .font(.appCaption)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.lg)
        }
    }

    private func toggleRow(_ icon: String, _ color: Color, _ label: String, _ sub: String?, _ binding: Binding<Bool>, showsDivider: Bool = true) -> some View {
        SettingsListRow(
            systemImage: icon,
            iconColor: color,
            label: label,
            sub: sub,
            showsDivider: showsDivider
        ) {
            AppToggle(isOn: binding)
        }
    }
}

public struct WorkoutRemindersView: View {
    @State private var days: Set<String> = ["Mon", "Wed", "Fri"]
    @State private var hour: Int = 7
    @State private var minute: Int = 0
    @State private var meridiem: String = "AM"
    @State private var lead: String = "30 min"

    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let hourOptions = [5, 6, 7, 8, 9, 10, 11, 12]
    private let minuteOptions = [0, 15, 30, 45]
    private let leadOptions = ["15 min before", "30 min", "1 hour"]

    public init() {}

    public var body: some View {
        SettingsScreen(title: SettingsConstants.WorkoutReminders.title, showsSaveCTA: true, ctaTitle: SettingsConstants.WorkoutReminders.ctaTitle) {
            SettingsListHeader(SettingsConstants.WorkoutReminders.daysHeader)
            HStack(spacing: 6) {
                ForEach(dayLabels, id: \.self) { day in
                    Button {
                        if days.contains(day) { days.remove(day) } else { days.insert(day) }
                    } label: {
                        Text(day)
                            .font(.system(size: 12, weight: .bold))
                            .tracking(0.4)
                            .foregroundStyle(days.contains(day) ? .white : AppColor.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(days.contains(day) ? AppColor.brand : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(days.contains(day) ? AppColor.brand : AppColor.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            SettingsListHeader(SettingsConstants.WorkoutReminders.timeHeader)
            AppCard(padding: 16) {
                HStack(spacing: 8) {
                    timeWheel(value: hour, options: hourOptions, onChange: { hour = $0 }) { String(format: "%02d", $0) }
                    Text(":")
                        .font(.system(size: 32, weight: .black, design: .monospaced))
                        .foregroundStyle(AppColor.textPrimary)
                    timeWheel(value: minute, options: minuteOptions, onChange: { minute = $0 }) { String(format: "%02d", $0) }
                    timeWheel(value: meridiem, options: ["AM", "PM"], onChange: { meridiem = $0 }) { $0 }
                }
                .frame(maxWidth: .infinity)
            }

            SettingsListHeader(SettingsConstants.WorkoutReminders.leadHeader)
            FilterChips(
                options: leadOptions,
                selected: lead,
                label: { $0 },
                onSelect: { lead = $0 }
            )

            Text(reminderSummary)
                .font(.appBody)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.top, AppSpacing.sm)
        }
    }

    private var reminderSummary: String {
        let dayList = dayLabels.filter { days.contains($0) }.joined(separator: ", ")
        let h = String(format: "%02d", hour)
        let m = String(format: "%02d", minute)
        return "You'll be notified on \(dayList) at \(h):\(m) \(meridiem) · \(lead)"
    }

    private func timeWheel<T: Equatable>(
        value: T,
        options: [T],
        onChange: @escaping (T) -> Void,
        format: @escaping (T) -> String
    ) -> some View {
        let idx = options.firstIndex(of: value) ?? 0
        let prevIdx = (idx - 1 + options.count) % options.count
        let nextIdx = (idx + 1) % options.count
        return VStack(spacing: 4) {
            Button { onChange(options[prevIdx]) } label: {
                Text(format(options[prevIdx]))
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(AppColor.textHint)
            }
            .buttonStyle(.plain)
            Text(format(value))
                .font(.system(size: 32, weight: .black, design: .monospaced))
                .foregroundStyle(AppColor.textPrimary)
            Button { onChange(options[nextIdx]) } label: {
                Text(format(options[nextIdx]))
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(AppColor.textHint)
            }
            .buttonStyle(.plain)
        }
        .frame(width: 70)
    }
}

#Preview("Notifications") {
    NavigationStack {
        NotificationsSettingsView()
    }
}

#Preview("Workout Reminders") {
    NavigationStack {
        WorkoutRemindersView()
    }
}
