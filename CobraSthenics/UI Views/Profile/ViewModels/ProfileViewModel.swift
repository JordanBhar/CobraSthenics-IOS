import SwiftUI

@Observable
@MainActor
final class ProfileViewModel {

    func initials(for name: String) -> String {
        let parts = name.components(separatedBy: " ").filter { !$0.isEmpty }
        let firsts = parts.prefix(2).compactMap { $0.first.map(String.init) }
        return firsts.joined().uppercased()
    }

    func prValueDisplay(for pr: PersonalRecord) -> String {
        PersonalRecordFormatter.valueDisplay(for: pr)
    }

    func prAccent(for pr: PersonalRecord) -> Color {
        if pr.bestHoldSeconds != nil { return AppColor.green }
        if pr.bestWeightKg != nil { return AppColor.brand }
        return AppColor.gold
    }
}
