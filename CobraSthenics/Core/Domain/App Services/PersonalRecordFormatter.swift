import Foundation

enum PersonalRecordFormatter {

    static let emptyValue = "—"

    static func valueDisplay(for pr: PersonalRecord) -> String {
        if let hold = pr.bestHoldSeconds { return String(format: "%.1fs", hold) }
        if let reps = pr.bestReps { return "\(reps) reps" }
        if let weight = pr.bestWeightKg { return "+\(weight)kg" }
        return emptyValue
    }
}
