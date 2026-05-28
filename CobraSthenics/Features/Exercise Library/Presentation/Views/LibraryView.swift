import SwiftUI

public struct LibraryView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var viewModel: LibraryViewModel

    public init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    AppHeader(
                        eyebrow: "Browse",
                        title: "Library",
                        subtitle: "400+ calisthenics exercises · filter by category"
                    )
                    SearchField(text: $viewModel.searchText, placeholder: "Search exercises, skills, programs")
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: AppSpacing.xs),
                                         GridItem(.flexible(), spacing: AppSpacing.xs)],
                              spacing: AppSpacing.xs) {
                        ForEach(viewModel.filteredCategories) { category in
                            NavigationLink {
                                CategoryView(category: category, exerciseRepository: environment.exerciseRepository)
                            } label: {
                                categoryCard(category)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppLayout.bottomBarClearance)
            }
        }
        .task { await viewModel.load() }
        .appNavigationBarHidden(true)
    }

    private func categoryCard(_ category: ExerciseCategory) -> some View {
        GradientCard(colors: category.colors, accent: category.accent, radius: AppRadius.md, padding: 14) {
            VStack(alignment: .leading, spacing: 0) {
                AccentPill(category.tag, color: category.accent)
                Spacer(minLength: 6)
                Text(category.name)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(.white)
                    .padding(.top, AppSpacing.xs)
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(category.exerciseCount)")
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundStyle(category.accent)
                    Text("exercises")
                        .font(.appCaption)
                        .foregroundStyle(AppColor.textHint)
                }
                .padding(.top, 4)
            }
            .frame(height: 110, alignment: .topLeading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView(viewModel: LibraryViewModel(exerciseRepository: SampleExerciseRepository()))
    }
    .environment(AppEnvironment.preview)
}
