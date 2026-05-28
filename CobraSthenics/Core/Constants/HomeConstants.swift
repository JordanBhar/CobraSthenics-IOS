import Foundation

enum HomeConstants {
    static let greeting = "Good morning 👋"
    static let notificationIcon = "bell"

    enum Streak {
        static let emoji = "🔥"
        static let dayStreakLabel = "Day Streak"
    }

    enum Stats {
        static let sessionsIcon = "dumbbell.fill"
        static let sessionsTitle = "3 / 5 sessions"
        static let setsIcon = "chart.bar.fill"
        static let setsTitle = "2,840 total sets"
    }

    enum Program {
        static let weekLabel = "Week"
        static let dayLabel = "Day"
        static let continueButtonTitle = "Continue Today's Session"
        static let continueButtonIcon = "arrow.right"
    }

    enum SkillFocus {
        static let sectionTitle = "Skill Focus"
        static let sectionAction = "All Skills"
        static let lastLabel = "Last:"
        static let targetLabel = "Target:"
        static let separator = "·"
        static let emptyValue = "—"
        static let icon = "target"
        static let playIcon = "play.fill"
    }

    enum RecentActivity {
        static let sectionTitle = "Recent Activity"
        static let sectionAction = "History"
        static let skillEmoji = "🎯"
        static let workoutEmoji = "💪"
        static let chevronIcon = "chevron.right"
    }
}
