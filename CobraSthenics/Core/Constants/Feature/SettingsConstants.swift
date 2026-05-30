import Foundation

enum SettingsConstants {

    enum EditProfile {
        static let title = "Edit Profile"
        static let saveButton = "Save"
        static let saveCTA = "Save Changes"
        static let displayNameLabel = "Display name"
        static let usernameLabel = "Username"
        static let bioLabel = "Bio"
        static let locationLabel = "Location"
        static let locationIcon = "mappin.and.ellipse"
        static let publicProfileHeader = "Public profile"
        static let showPublicLabel = "Show profile publicly"
        static let showPublicSub = "Anyone can view your stats and achievements"
        static let showActivityLabel = "Show workout activity"
        static let showActivitySub = "Display recent sessions on your profile"
        static let publicIcon = "globe"
        static let activityIcon = "waveform.path.ecg"
        static let changePhoto = "Change photo"
        static let cameraIcon = "camera.fill"
    }

    enum ChangePassword {
        static let title = "Change Password"
        static let ctaTitle = "Update Password"
        static let intro = "Choose a strong password you don't use anywhere else. You'll be signed out of all other devices."
        static let currentPasswordLabel = "Current password"
        static let newPasswordLabel = "New password"
        static let confirmPasswordLabel = "Confirm new password"
        static let strengthStrong = "STRONG"
        static let requirementMinLength = "8+ characters"
        static let requirementUppercase = "Uppercase letter"
        static let requirementNumberSymbol = "Number or symbol"
        static let requirementNotReused = "Not same as last password"
        static let eyeOpen = "eye"
        static let eyeClosed = "eye.slash"
    }

    enum ConnectedApps {
        static let title = "Connected Apps"
        static let intro = "Sync workouts and health data with your favourite health platforms."
        static let connectedHeader = "Connected (2)"
        static let availableHeader = "Available"
        static let connectedBadge = "CONNECTED"
        static let connectButton = "Connect"
        static let managePermissions = "Manage permissions ›"
        static let appleHealthName = "Apple Health"
        static let appleHealthSub = "Syncing workouts, active energy, heart rate"
        static let googleFitName = "Google Fit"
        static let googleFitSub = "Syncing workout duration and calories"
        static let garminName = "Garmin Connect"
        static let garminSub = "Not connected"
        static let stravaName = "Strava"
        static let stravaSub = "Share workouts automatically"
    }

    enum ExportData {
        static let title = "Export Data"
        static let ctaTitle = "Request Export"
        static let intro = "Download a complete copy of your Cobrasthenics data. Includes all workouts, skill logs, PRs, and settings."
        static let formatHeader = "Format"
        static let includeHeader = "Include"
        static let dateRangeHeader = "Date range"
        static let formats = ["JSON", "CSV", "PDF Report"]
        static let ranges = ["Last 30 days", "Last 90 days", "This year", "All time"]
        static let workoutsLabel = "Workout history"
        static let workoutsSub = "All sessions, sets, reps, holds"
        static let skillsLabel = "Skill progression logs"
        static let skillsSub = "Hold times, tier changes"
        static let prsLabel = "Personal records"
        static let prsSub = "All-time bests with dates"
        static let bodyLabel = "Body measurements"
        static let bodySub = "Weight, body fat, circumferences"
        static let chatLabel = "Chat / AI coach history"
        static let chatSub = "Coach conversations and form reviews"
        static let settingsLabel = "App settings"
        static let settingsSub = "Preferences and notification toggles"
        static let exportReadyInfo = "Your export will be ready within a few minutes and sent to "
    }

    enum Appearance {
        static let title = "Appearance"
        static let footer = "Cobrasthenics is a dark-first experience. Additional themes are in development."
        static let comingSoon = "COMING SOON"
        static let darkLabel = "Dark"
        static let darkSub = "The default Cobrasthenics experience"
        static let lightLabel = "Light"
        static let lightSub = "High contrast light mode"
        static let systemLabel = "Match system"
        static let systemSub = "Follows your iOS appearance setting"
    }

    enum Language {
        static let title = "Language"
        static let searchPlaceholder = "Search languages…"
        static let currentHeader = "Current"
        static let allHeader = "All languages"
        static let restartFooter = "Changing language restarts the app."
    }

    enum Notifications {
        static let title = "Notification Settings"
        static let intro = "Cobrasthenics will only ping you for things that matter — toggle off anything that doesn't."
        static let workoutsHeader = "Workouts"
        static let skillsHeader = "Skills"
        static let coachHeader = "Coach"
        static let socialHeader = "Social"
        static let footer = "You can pause all notifications from your iOS Settings → Cobrasthenics → Notifications."

        static let sessionRemindersLabel = "Session reminders"
        static let sessionRemindersSub = "Scheduled training nudges"
        static let restTimerLabel = "Rest timer alerts"
        static let restTimerSub = "Vibrate when your set rest ends"
        static let workoutSummaryLabel = "Workout complete summary"
        static let workoutSummarySub = "Push notification after each session"

        static let prAchievedLabel = "PR achieved alerts"
        static let prAchievedSub = "Celebrate new personal records"
        static let tierUnlockedLabel = "Skill tier unlocked"
        static let tierUnlockedSub = "When you progress to the next tier"
        static let coachGoalsLabel = "Coach goal updates"
        static let coachGoalsSub = "Weekly skill targets from your AI coach"

        static let weeklyPlanLabel = "Weekly plan ready"
        static let weeklyPlanSub = "Sundays at 7:00 AM"
        static let recoveryLabel = "Recovery suggestions"
        static let recoverySub = "Rest-day or deload prompts"
        static let formAnalysisLabel = "Form analysis results"
        static let formAnalysisSub = "Notify when AI form review is ready"

        static let newFollowersLabel = "New followers"
        static let postReactionsLabel = "Post reactions"
        static let mentionsLabel = "Community mentions"
        static let mentionsSub = "When someone @mentions you"
    }

    enum WorkoutReminders {
        static let title = "Workout Reminders"
        static let ctaTitle = "Save Reminder"
        static let daysHeader = "Reminder days"
        static let timeHeader = "Reminder time"
        static let leadHeader = "Lead time"
    }

    enum RestTimer {
        static let title = "Default Rest Timer"
        static let presetsHeader = "Presets"
        static let customHeader = "Or set custom time"
        static let overridesHeader = "Per-category overrides"
        static let betweenSetsLabel = "BETWEEN SETS"
        static let perCategoryLabel = "Different rest per exercise type"
        static let perCategorySub = "Override for strength, skill, conditioning"
        static let strengthOverride = "Strength sets"
        static let skillOverride = "Skill holds"
        static let conditioningOverride = "Conditioning"
        static let footer = "Used as the default between all sets unless overridden per-exercise in the workout builder."
    }

    enum Subscription {
        static let title = "Subscription"
        static let billingHeader = "Billing"
        static let unlockedHeader = "What's unlocked"
        static let changePlanHeader = "Change plan"
        static let manageHeader = "Manage"
        static let cancelHeader = "Cancel"
        static let premiumActiveBadge = "Premium · Active"
        static let brandTitle = "Cobrasthenics"
        static let premiumWord = "Premium"
        static let planLabel = "Plan"
        static let memberSinceLabel = "Member since"
        static let nextBillingLabel = "Next billing"
        static let appStoreLabel = "Apple App Store"
        static let appStoreSub = "Renews via App Store · Apple ID purchase"
        static let nextChargeLabel = "Next charge"
        static let autoRenewLabel = "Auto-renew"
        static let autoRenewOn = "Renews automatically"
        static let autoRenewOffPrefix = "Will end on "
        static let monthlyName = "Premium Monthly"
        static let monthlyPrice = "$9.99"
        static let monthlyPeriod = "per month"
        static let annualName = "Premium Annual"
        static let annualPrice = "$59.99"
        static let annualPeriod = "per year"
        static let annualSubline = "$5.00/mo — save 50%"
        static let bestValueBadge = "Best Value"
        static let manageAppStoreLabel = "Manage in App Store"
        static let manageAppStoreSub = "Update payment, change plan, restore"
        static let billingHistoryLabel = "Billing history"
        static let restoreLabel = "Restore purchases"
        static let cancelLabel = "Cancel subscription"
        static let cancelSubPrefix = "Premium access continues until "
    }

    enum HelpFAQ {
        static let title = "Help & FAQ"
        static let searchPlaceholder = "Search help articles…"
        static let popularHeader = "Popular topics"
        static let contactHeader = "Contact"
        static let chatTitle = "Chat with support"
        static let chatSub = "Live chat · usually responds in minutes"
        static let emailTitle = "Email us"
        static let emailSub = "Usually responds within 24 hours"
    }

    enum Feedback {
        static let title = "Send Feedback"
        static let ctaTitle = "Send Feedback"
        static let typeHeader = "Feedback type"
        static let satisfactionHeader = "Overall satisfaction · optional"
        static let types = ["Bug report", "Feature request", "General", "Design", "Performance"]
        static let subjectLabel = "Subject"
        static let messageLabel = "MESSAGE"
        static let messageCounterFormat = "%d / 500"
        static let attachScreenshotLabel = "Attach current screenshot"
        static let attachScreenshotSub = "Helps the team see what you saw"
        static let footer = "Your feedback goes directly to the Cobrasthenics team. We read every message."
    }

    enum DeleteAccount {
        static let title = "Delete Account"
        static let ctaTitle = "Delete My Account"
        static let goBack = "Changed your mind? Go back"
        static let warningTitle = "This cannot be undone"
        static let warningBody = "Deleting your account permanently removes all your workouts, skill progress, PRs, and profile data. This action is irreversible."
        static let willDeleteHeader = "What will be deleted"
        static let beforeYouGoHeader = "Before you go"
        static let confirmHeader = "Type DELETE to confirm"
        static let confirmKeyword = "DELETE"
        static let confirmPlaceholder = "DELETE"
        static let clearAction = "Clear"
        static let typeDeleteAction = "Type DELETE"
        static let exportTitle = "Export your data first"
        static let exportSub = "JSON, CSV or PDF — keep a record of your training"
        static let pauseTitle = "Pause your account instead"
        static let pauseSub = "Keep your data; come back any time"
        static let exportIcon = "square.and.arrow.down"
        static let pauseIcon = "pause.circle"

        static let deletionItems: [String] = [
            "All workout history and logged sets",
            "All skill progression and tier data",
            "All personal records and achievements",
            "Your profile and all public posts",
            "Your active Premium subscription (no refund)"
        ]
    }
}
