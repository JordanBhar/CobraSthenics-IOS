import Foundation

enum SkillsConstants {
    enum Header {
        static let eyebrow = "Progression"
        static let title = "Skills"
        static let activeSuffix = "active"
        static let lockedSuffix = "locked"
        static let masteredSuffix = "mastered"
        static let separator = "·"
    }

    enum Filters {
        static let allSkills = "All Skills"
        static let allKey = "all"
    }

    enum Stats {
        static let activeLabel = "Active"
        static let activeIcon = "bolt.fill"
        static let sessionsLabel = "Sessions"
        static let sessionsIcon = "calendar"
        static let sessionsValue = "47"
        static let prsLabel = "PRs Set"
        static let prsIcon = "trophy.fill"
        static let prsValue = "12"
    }

    enum Card {
        static let lockedIcon = "lock.fill"
        static let unlockedIcon = "target"
        static let chevronIcon = "chevron.right"
        static let lockedSubtitle = "Complete prerequisites to unlock"
        static let tierLabel = "Tier"
        static let tierOfLabel = "of"
        static let bestLabel = "BEST"
        static let targetLabel = "TARGET"
        static let progressLabel = "PROGRESS"
        static let emptyValue = "—"
    }

    enum Actions {
        static let train = "Train"
        static let trainIcon = "play.fill"
        static let analyseForm = "Analyse Form"
        static let analyseFormIcon = "camera"
    }

    enum Detail {
        static let tierEyebrowFormat = "%@ · TIER %d OF %d"
        static let tierProgressPrefix = "Tier Progress"
        static let primaryMusclesTitle = "Primary Muscles"
        static let secondaryMusclesTitle = "Secondary Muscles"
        static let holdTypeLabel = "HOLD TYPE"
        static let holdTypeDescription = "Static isometric hold — sustained position under maximal tension. Build hold time progressively before advancing tier."
        static let prBadge = "PR"
        static let emptyHistoryMessage = "No sessions logged yet"
        static let ctaTrain = "Train Skill"
        static let ctaTrainIcon = "play.fill"
        static let ctaAnalyse = "Analyse Form"
        static let ctaAnalyseIcon = "camera"
        static let backIcon = "chevron.left"
    }

    enum Tabs {
        static let instructions = "Instructions"
        static let muscles = "Muscles"
        static let history = "History"
    }
}
