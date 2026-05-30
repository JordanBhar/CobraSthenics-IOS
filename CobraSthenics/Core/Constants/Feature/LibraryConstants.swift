import Foundation

enum LibraryConstants {
    enum Header {
        static let eyebrow = "Browse"
        static let title = "Library"
        static let subtitle = "400+ calisthenics exercises · filter by category"
    }

    enum Search {
        static let placeholder = "Search exercises, skills, programs"
        static let categoryPlaceholderFormat = "Search %d exercises…"
    }

    enum Category {
        static let exercisesSuffix = "exercises"
        static let exerciseSingular = "exercise"
        static let exercisesLabel = "Exercises"
        static let loggedLabel = "Logged"
        static let prsLabel = "PRs"
        static let emptyFilterMessage = "No exercises in this difficulty.\nTry a different filter."
        static let emptySearchFormat = "No results for \"%@\""
        static let chevronIcon = "chevron.right"
    }

    enum ExerciseIcon {
        static let timed = "timer"
        static let amrap = "flame"
        static let reps = "dumbbell.fill"
    }

    enum Detail {
        static let navigationTitle = "Exercise"
        static let targetLabel = "Target"
        static let setsLabel = "Sets"
        static let bestHoldLabel = "Best Hold"
        static let bestRepsLabel = "Best Reps"
        static let emptyValue = "—"
        static let progressionChainTitle = "PROGRESSION CHAIN"
        static let chainEasier = "Easier"
        static let chainCurrent = "Current"
        static let chainHarder = "Harder"
        static let chainPlaceholderStart = "Start here"
        static let chainPlaceholderMastered = "Mastered"
        static let coachingCuesTitle = "Coaching Cues"
        static let coachingCuesIcon = "checkmark"
        static let commonMistakesTitle = "Common Mistakes"
        static let commonMistakesIcon = "xmark"
        static let primaryMusclesTitle = "Primary Muscles"
        static let secondaryMusclesTitle = "Secondary Muscles"
        static let exerciseTypeLabel = "EXERCISE TYPE"
        static let exerciseTypeTimed = "Static isometric hold — sustained position under tension."
        static let exerciseTypeAmrap = "AMRAP — as many reps as possible to fatigue."
        static let exerciseTypeReps = "Rep-based set — counted through full range of motion."
        static let ctaAddToWorkout = "Add to Workout"
        static let ctaAddIcon = "plus"
        static let ctaLogSet = "Log Set"
        static let ctaLogIcon = "checkmark"
        
        enum DetailTabs {
            static let instructions = "Instructions"
            static let cuesMistakes = "Cues & Mistakes"
            static let muscles = "Muscles"
        }
        
        enum DetailVideo {
            static let sectionTitle = "WATCH THE MOVEMENT"
            static let formDemoLabel = "FORM DEMO"
            static let formDemoIcon = "video.fill"
            static let qualityLabel = "HD"
            static let playIcon = "play.fill"
        }
        
    }
}
