//
//  Weekday.swift
//  CobraSthenics
//

import Foundation

public struct WeekDay: Identifiable, Codable, Hashable {
    public let id: String
    public let label: String
    public let completed: Bool
    public let isToday: Bool

    public init(id: String = UUID().uuidString, label: String, completed: Bool, isToday: Bool = false) {
        self.id = id
        self.label = label
        self.completed = completed
        self.isToday = isToday
    }
}

extension WeekDay {

    /// Returns Monday–Sunday for the week containing `today`, marking which day
    /// is today and which days already have a completed `WorkoutSession`.
    static func currentWeek(
        today: Date = .now,
        completedSessionDates: [Date],
        calendar: Calendar = .current
    ) -> [WeekDay] {
        var weekCalendar = calendar
        weekCalendar.firstWeekday = 2 // Monday

        guard let weekInterval = weekCalendar.dateInterval(of: .weekOfYear, for: today) else {
            return []
        }

        let labels = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
        let completedDayStarts = Set(completedSessionDates.map { weekCalendar.startOfDay(for: $0) })
        let todayStart = weekCalendar.startOfDay(for: today)

        return (0..<7).compactMap { offset in
            guard let dayStart = weekCalendar.date(byAdding: .day, value: offset, to: weekInterval.start) else {
                return nil
            }
            return WeekDay(
                id: "\(dayStart.timeIntervalSince1970)",
                label: labels[offset],
                completed: completedDayStarts.contains(dayStart),
                isToday: dayStart == todayStart
            )
        }
    }
}
