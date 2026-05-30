import Foundation

@Observable
@MainActor
final class HomeViewModel {

    static let sessionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    func firstName(for user: User?) -> String {
        let name = user?.displayName ?? user?.username ?? HomeConstants.defaultAthleteName
        return name.components(separatedBy: " ").first ?? name
    }

    func recentCompletedSessions(from sessions: [WorkoutSession], limit: Int = 5) -> [WorkoutSession] {
        sessions.lazy.filter { $0.completedAt != nil }.prefix(limit).map { $0 }
    }

    func weekDays(from sessions: [WorkoutSession]) -> [WeekDay] {
        let completedDates = sessions.compactMap { $0.completedAt }
        return WeekDay.currentWeek(completedSessionDates: completedDates)
    }

    func sessionMetaLabel(_ session: WorkoutSession) -> String {
        let dateLabel = session.completedAt.map { Self.sessionDateFormatter.string(from: $0) } ?? HomeConstants.RecentActivity.emptyValue
        let setCount = session.completedExercises.reduce(0) { $0 + $1.setsCompleted }
        let durationLabel = durationMinutesLabel(for: session) ?? HomeConstants.RecentActivity.emptyValue
        return "\(dateLabel) · \(setCount) sets · \(durationLabel)"
    }

    private func durationMinutesLabel(for session: WorkoutSession) -> String? {
        guard let completedAt = session.completedAt else { return nil }
        let minutes = Int(completedAt.timeIntervalSince(session.startedAt) / 60)
        guard minutes >= 0 else { return nil }
        return "\(minutes) min"
    }
}
