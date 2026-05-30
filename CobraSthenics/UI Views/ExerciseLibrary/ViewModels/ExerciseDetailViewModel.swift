import Foundation
import SwiftData

@Observable
@MainActor
final class ExerciseDetailViewModel {

    enum Tab: CaseIterable, Hashable {
        case instructions, cuesMistakes, muscles

        var title: String {
            switch self {
            case .instructions: return LibraryConstants.Detail.DetailTabs.instructions
            case .cuesMistakes: return LibraryConstants.Detail.DetailTabs.cuesMistakes
            case .muscles: return LibraryConstants.Detail.DetailTabs.muscles
            }
        }
    }

    var selectedTab: Tab = .instructions
    private(set) var previousExercise: Exercise?
    private(set) var nextExercise: Exercise?
    private(set) var personalRecord: PersonalRecord?

    func loadRelations(for exercise: Exercise, in context: ModelContext) {
        if let prevID = exercise.previousExerciseID {
            previousExercise = Self.fetchExercise(id: prevID, in: context)
        }
        if let nextID = exercise.nextExerciseID {
            nextExercise = Self.fetchExercise(id: nextID, in: context)
        }
        personalRecord = Self.fetchPersonalRecord(for: exercise.id, in: context)
    }

    private static func fetchExercise(id: UUID, in context: ModelContext) -> Exercise? {
        let descriptor = FetchDescriptor<Exercise>(predicate: #Predicate { $0.id == id })
        return try? context.fetch(descriptor).first
    }

    private static func fetchPersonalRecord(for exerciseID: UUID, in context: ModelContext) -> PersonalRecord? {
        let descriptor = FetchDescriptor<PersonalRecord>(
            predicate: #Predicate { $0.exercise.id == exerciseID }
        )
        return try? context.fetch(descriptor).first
    }

    func prText(isTimed: Bool) -> String {
        guard let pr = personalRecord else { return LibraryConstants.Detail.emptyValue }
        return PersonalRecordFormatter.valueDisplay(for: pr)
    }

    func prLabel(isTimed: Bool) -> String {
        isTimed ? LibraryConstants.Detail.bestHoldLabel : LibraryConstants.Detail.bestRepsLabel
    }

    func targetText(isTimed: Bool) -> String {
        isTimed ? "3 × hold" : "3 × 8–12"
    }

    func setTypeLabel(isTimed: Bool) -> String {
        isTimed ? "Timed Hold" : "Rep Based"
    }

    func exerciseTypeDescription(isTimed: Bool) -> String {
        isTimed ? LibraryConstants.Detail.exerciseTypeTimed : LibraryConstants.Detail.exerciseTypeReps
    }
}
