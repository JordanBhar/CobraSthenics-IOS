import Foundation

enum ProfileConstants {
    static let usernamePrefix = "@"
    static let levelAbbreviation = "Lvl"
    static let settingsIcon = "gearshape"

    enum XP {
        static let labelPrefix = "XP TO LVL"
        static let separator = "/"
    }

    enum QuickStats {
        static let workouts = "Workouts"
        static let dayStreak = "Day streak"
        static let skills = "Skills"
        static let personalRecords = "PRs"
    }

    enum Achievements {
        static let sectionTitle = "Achievements"
        static let sectionAction = "All"
    }

    enum PersonalRecords {
        static let sectionTitle = "Personal Records"
        static let sectionAction = "All PRs"
        static let trophyIcon = "trophy.fill"
    }

    enum Settings {
        static let sectionTitle = "Settings"
        static let chevronIcon = "chevron.right"
    }
}
