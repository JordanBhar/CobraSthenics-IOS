import SwiftUI
import SwiftData

public struct LibraryView: View {

    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @State private var viewModel = LibraryViewModel()

    public init() {}

    public var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    AppHeader(
                        eyebrow: LibraryConstants.Header.eyebrow,
                        title: LibraryConstants.Header.title,
                        subtitle: LibraryConstants.Header.subtitle
                    )
                    SearchField(text: $viewModel.searchText, placeholder: LibraryConstants.Search.placeholder)
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: AppSpacing.xs),
                                         GridItem(.flexible(), spacing: AppSpacing.xs)],
                              spacing: AppSpacing.xs) {
                        ForEach(viewModel.filteredCategories(), id: \.self) { category in
                            NavigationLink(value: category) {
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
        .navigationDestination(for: ExerciseCategory.self) { category in
            CategoryView(category: category)
        }
        .appNavigationBarHidden(true)
    }

    private func categoryCard(_ category: ExerciseCategory) -> some View {
        GradientCard(colors: category.colors, accent: category.accent, radius: AppRadius.md, padding: 14) {
            VStack(alignment: .leading, spacing: 0) {
                AccentPill(category.tag, color: category.accent)
                Spacer(minLength: 6)
                Text(category.title)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(.white)
                    .padding(.top, AppSpacing.xs)
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(viewModel.count(of: category, in: exercises))")
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundStyle(category.accent)
                    Text(LibraryConstants.Category.exercisesSuffix)
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
        LibraryView()
    }
    .modelContainer(PreviewModelContainer.shared)
}
