import Foundation

public enum SampleData {
    static let brand: UInt = 0x0A84FF
    static let green: UInt = 0x30D158
    static let red: UInt = 0xFF453A
    static let gold: UInt = 0xFFB800
    static let orange: UInt = 0xFF9F0A
    static let purple: UInt = 0xBF5AF2
    static let teal: UInt = 0x4DD0E1

    public static let user = UserProfileModel(
        id: "sample-uid",
        displayName: "Jordan Bhar",
        username: "ObsidianCobra",
        avatarURL: nil,
        level: 12,
        levelTitle: "Ring God",
        currentXP: 2340,
        xpToNextLevel: 3000,
        workoutCount: 47,
        streakDays: 14,
        activeSkills: 3,
        prCount: 12,
        isPremium: true,
        bio: "Calisthenics athlete. Chasing planche & front lever.",
        achievements: [
            Achievement(id: "1", emoji: "F", name: "On Fire", isEarned: true),
            Achievement(id: "2", emoji: "M", name: "Iron Grip", isEarned: true),
            Achievement(id: "3", emoji: "T", name: "Skill Master", isEarned: true),
            Achievement(id: "4", emoji: "50", name: "50 Club", isEarned: false),
            Achievement(id: "5", emoji: "*", name: "Milestone", isEarned: false),
            Achievement(id: "6", emoji: "L", name: "Locked", isEarned: false)
        ]
    )

    public static let weekDays = [
        WeekDay(id: "Mon", label: "M", completed: true),
        WeekDay(id: "Tue", label: "T", completed: true),
        WeekDay(id: "Wed", label: "W", completed: true),
        WeekDay(id: "Thu", label: "T", completed: false, isToday: true),
        WeekDay(id: "Fri", label: "F", completed: false),
        WeekDay(id: "Sat", label: "S", completed: false),
        WeekDay(id: "Sun", label: "S", completed: false)
    ]

    public static let activeProgram = ActiveProgram(
        id: "prog-1",
        name: "Beginner Calisthenics",
        currentWeek: 3,
        totalWeeks: 8,
        currentDay: 2,
        totalDays: 5,
        adherencePercent: 35,
        level: "Beginner",
        workouts: [Workout](),
        colorPair: ColorPair(0x001530, 0x002860),
        accentHex: brand
    )

    public static let recentWorkouts = [
        RecentWorkout(id: "w1", name: "Push Day", dateLabel: "Yesterday", setCount: 28, duration: "38m", isSkillSession: false, backgroundHex: 0x001D42, accentHex: brand),
        RecentWorkout(id: "w2", name: "L-Sit Session", dateLabel: "2 days ago", setCount: 6, duration: "12m", isSkillSession: true, backgroundHex: 0x3A0808, accentHex: red),
        RecentWorkout(id: "w3", name: "Leg Day", dateLabel: "3 days ago", setCount: 24, duration: "41m", isSkillSession: false, backgroundHex: 0x2E2000, accentHex: gold)
    ]

    public static let workouts = [
        Workout(id: "w1", name: "Pull Day", duration: "45 min", exerciseCount: 6, muscles: ["Back", "Biceps"], level: "Intermediate", colorPair: ColorPair(0x0A2E1A, 0x0E5C30), accentHex: green, category: .strength, exercises: [Exercise]()),
        Workout(id: "w2", name: "Push Day", duration: "40 min", exerciseCount: 7, muscles: ["Chest", "Triceps"], level: "Intermediate", colorPair: ColorPair(0x001D42, 0x003E8A), accentHex: brand, category: .strength, exercises: [Exercise]()),
        Workout(id: "w3", name: "Core Foundations", duration: "25 min", exerciseCount: 5, muscles: ["Core"], level: "Beginner", colorPair: ColorPair(0x3A0808, 0x7A1010), accentHex: red, category: .strength, exercises: [Exercise]()),
        Workout(id: "w4", name: "Leg Power", duration: "35 min", exerciseCount: 6, muscles: ["Quads", "Glutes"], level: "Advanced", colorPair: ColorPair(0x2E2000, 0x614400), accentHex: gold, category: .strength, exercises: [Exercise]()),
        Workout(id: "w5", name: "Ring Strength", duration: "50 min", exerciseCount: 8, muscles: ["Chest", "Back"], level: "Advanced", colorPair: ColorPair(0x2B0A4F, 0x5A1A99), accentHex: purple, category: .rings, exercises: [Exercise]())
    ]

    public static let categories = [
        ExerciseCategory(id: "chest", name: "Chest", tag: "Push", exerciseCount: 8, colorPair: ColorPair(0x001D42, 0x003E8A), accentHex: brand),
        ExerciseCategory(id: "back", name: "Back", tag: "Pull", exerciseCount: 8, colorPair: ColorPair(0x0A2E1A, 0x0E5C30), accentHex: green),
        ExerciseCategory(id: "shoulders", name: "Shoulders", tag: "Press", exerciseCount: 6, colorPair: ColorPair(0x2B0A4F, 0x5A1A99), accentHex: purple),
        ExerciseCategory(id: "arms", name: "Arms", tag: "Curl/Ext", exerciseCount: 7, colorPair: ColorPair(0x3A1200, 0x7A2800), accentHex: orange),
        ExerciseCategory(id: "core", name: "Core", tag: "Static", exerciseCount: 8, colorPair: ColorPair(0x3A0808, 0x7A1010), accentHex: red),
        ExerciseCategory(id: "legs", name: "Legs", tag: "Squat", exerciseCount: 6, colorPair: ColorPair(0x2E2000, 0x614400), accentHex: gold),
        ExerciseCategory(id: "full_body", name: "Full Body", tag: "Compound", exerciseCount: 6, colorPair: ColorPair(0x001830, 0x003366), accentHex: teal),
        ExerciseCategory(id: "mobility", name: "Mobility", tag: "Stretch", exerciseCount: 8, colorPair: ColorPair(0x002222, 0x004444), accentHex: 0x4DD0E1)
    ]

    public static let exercises = [
        Exercise(id: "push-up", name: "Push-Up", category: "chest", mechanics: "compound", force: "push", primaryMuscles: ["Chest"], secondaryMuscles: ["Triceps", "Shoulders"], equipment: "bodyweight", difficulty: .beginner, defaultSetType: .reps, isSkillExercise: false, progression: ProgressionChain(previousID: nil, nextID: "diamond-push-up"), description: "Classic horizontal push pattern.", instructions: ["Set hands under shoulders.", "Brace core.", "Lower with control.", "Press back to lockout."], tips: ["Keep ribs down."], commonMistakes: ["Sagging hips"], personalRecord: PersonalRecord(bestReps: 42, bestHoldSeconds: nil, bestWeightKg: nil), colorPair: ColorPair(0x001D42, 0x003E8A), accentHex: brand),
        Exercise(id: "pull-up", name: "Pull-Up", category: "back", mechanics: "compound", force: "pull", primaryMuscles: ["Back"], secondaryMuscles: ["Biceps"], equipment: "pull_up_bar", difficulty: .intermediate, defaultSetType: .reps, isSkillExercise: false, progression: ProgressionChain(previousID: "scapular-pull", nextID: "chest-to-bar"), description: "Vertical pulling benchmark.", instructions: ["Hang from bar.", "Pull elbows to ribs.", "Clear chin over bar.", "Lower under control."], tips: ["Start with scapular depression."], commonMistakes: ["Kipping early"], personalRecord: PersonalRecord(bestReps: 20, bestHoldSeconds: nil, bestWeightKg: nil), colorPair: ColorPair(0x0A2E1A, 0x0E5C30), accentHex: green),
        Exercise(id: "l-sit", name: "L-Sit", category: "core", mechanics: "compound", force: "static_hold", primaryMuscles: ["Core", "Hip Flexors"], secondaryMuscles: ["Triceps"], equipment: "parallel_bars", difficulty: .advanced, defaultSetType: .timed, isSkillExercise: true, progression: ProgressionChain(previousID: "tuck-l-sit", nextID: "v-sit"), description: "Compression hold for core and support strength.", instructions: ["Press to support.", "Depress shoulders.", "Lift straight legs.", "Hold tension."], tips: ["Point toes."], commonMistakes: ["Bent elbows"], personalRecord: PersonalRecord(bestReps: nil, bestHoldSeconds: 12, bestWeightKg: nil), colorPair: ColorPair(0x3A0808, 0x7A1010), accentHex: red)
    ]

    public static let skills = [
        SkillModel(name: "Front Lever", family: "pull", currentTier: "Tuck", nextTier: "Adv. Tuck", tierIndex: 2, totalTiers: 5, bestDisplay: "8s", target: "10s", progressPercent: 80, colorPair: ColorPair(0x0A2E1A, 0x0E5C30), accentHex: green, status: .active, isStaticHold: true, instructions: ["Hang from bar with overhand grip.", "Depress and retract scapulae.", "Push bar toward hips to raise body horizontal.", "Hold with hips level."], primaryMuscles: ["Lats", "Core", "Rear Deltoids"], secondaryMuscles: ["Biceps", "Rhomboids"]),
        SkillModel(name: "Handstand", family: "push", currentTier: "Wall Supported", nextTier: "Kick-Up", tierIndex: 2, totalTiers: 6, bestDisplay: "42s", target: "60s", progressPercent: 70, colorPair: ColorPair(0x2B0A4F, 0x5A1A99), accentHex: purple, status: .active, isStaticHold: true, instructions: ["Hands close to wall.", "Kick up with control.", "Stack wrists, shoulders, hips, ankles.", "Push the floor away."], primaryMuscles: ["Shoulders", "Triceps", "Core"], secondaryMuscles: ["Wrists", "Forearms", "Traps"]),
        SkillModel(name: "L-Sit", family: "core", currentTier: "Tuck L-Sit", nextTier: "Full L-Sit", tierIndex: 2, totalTiers: 4, bestDisplay: "12s", target: "15s", progressPercent: 80, colorPair: ColorPair(0x3A0808, 0x7A1010), accentHex: red, status: .active, isStaticHold: true, instructions: ["Grip parallel bars.", "Press to straight-arm support.", "Extend legs forward.", "Squeeze quads."], primaryMuscles: ["Core", "Hip Flexors", "Triceps"], secondaryMuscles: ["Shoulders", "Quads"]),
        SkillModel(name: "Planche", family: "push", currentTier: "Planche Lean", nextTier: "Tuck Planche", tierIndex: 1, totalTiers: 6, bestDisplay: nil, target: "30s", progressPercent: 15, colorPair: ColorPair(0x001D42, 0x003E8A), accentHex: brand, status: .started, isStaticHold: true, instructions: ["Shift shoulders over wrists.", "Lock elbows.", "Protract scapulae.", "Build lean progressively."], primaryMuscles: ["Shoulders", "Serratus Anterior"], secondaryMuscles: ["Core", "Triceps"]),
        SkillModel(name: "Muscle-Up", family: "pull", currentTier: "Locked", nextTier: "Scapular Pull", tierIndex: 0, totalTiers: 5, bestDisplay: nil, target: "1 rep", progressPercent: 0, colorPair: ColorPair(0x1A1A00, 0x3A3A00), accentHex: gold, status: .locked, isStaticHold: false, instructions: ["Use a false grip.", "Initiate with explosive pull.", "Lean over the bar.", "Lock out in support."], primaryMuscles: ["Lats", "Chest", "Triceps"], secondaryMuscles: ["Biceps", "Core", "Shoulders"])
    ]

    public static let heatmap = [
        [2, 0, 2, 2, 0, 1, 2],
        [2, 2, 0, 2, 2, 0, 0],
        [1, 2, 2, 0, 2, 2, 1],
        [0, 2, 2, 2, 0, 2, 2]
    ]

    public static let personalRecords = [
        PrEntry(exerciseName: "Pull-Up", valueDisplay: "20 reps", accentHex: green),
        PrEntry(exerciseName: "Tuck Front Lever", valueDisplay: "8s", accentHex: green),
        PrEntry(exerciseName: "Weighted Dip", valueDisplay: "+20kg", accentHex: brand)
    ]

    public static let muscles = [
        MuscleStat(name: "Back", percent: 30),
        MuscleStat(name: "Chest", percent: 24),
        MuscleStat(name: "Core", percent: 20),
        MuscleStat(name: "Shoulders", percent: 13),
        MuscleStat(name: "Arms", percent: 8),
        MuscleStat(name: "Legs", percent: 5)
    ]

    public static let skillTrends = [
        SkillTrend(skillName: "Front Lever Hold", values: [3, 5, 5, 6, 7, 7, 8], unit: "s", colorHex: green),
        SkillTrend(skillName: "Handstand Hold", values: [15, 18, 20, 25, 28, 38, 42], unit: "s", colorHex: purple),
        SkillTrend(skillName: "Pull-Up Reps", values: [8, 10, 10, 12, 14, 14, 15], unit: "", colorHex: brand)
    ]

    public static let settingGroups = [
        SettingGroupModel(label: "Account", items: [
            SettingItemModel(systemImage: "square.and.pencil", colorHex: brand, label: "Edit Profile", route: .editProfile),
            SettingItemModel(systemImage: "lock", colorHex: green, label: "Change Password", route: .changePassword),
            SettingItemModel(systemImage: "bell", colorHex: orange, label: "Notifications", route: .notifications),
            SettingItemModel(systemImage: "timer", colorHex: brand, label: "Default Rest Timer", value: "2:00", route: .restTimer),
            SettingItemModel(systemImage: "calendar.badge.clock", colorHex: orange, label: "Workout Reminders", value: "Mon · Wed · Fri", route: .workoutReminders)
        ]),
        SettingGroupModel(label: "App", items: [
            SettingItemModel(systemImage: "sun.max", colorHex: purple, label: "Appearance", value: "Dark", route: .appearance),
            SettingItemModel(systemImage: "globe", colorHex: teal, label: "Language", value: "English", route: .language),
            SettingItemModel(systemImage: "iphone.gen3", colorHex: teal, label: "Connected Apps", value: "2 active", route: .connectedApps),
            SettingItemModel(systemImage: "square.and.arrow.down", colorHex: brand, label: "Export Data", route: .exportData),
            SettingItemModel(systemImage: "star.fill", colorHex: gold, label: "Subscription", badge: "Premium", route: .subscription)
        ]),
        SettingGroupModel(label: "Support", items: [
            SettingItemModel(systemImage: "questionmark.circle", colorHex: purple, label: "Help & FAQ", route: .helpFAQ),
            SettingItemModel(systemImage: "message", colorHex: brand, label: "Send Feedback", route: .feedback),
            SettingItemModel(systemImage: "trash", colorHex: red, label: "Delete Account", destructive: true, route: .deleteAccount)
        ])
    ]
}
