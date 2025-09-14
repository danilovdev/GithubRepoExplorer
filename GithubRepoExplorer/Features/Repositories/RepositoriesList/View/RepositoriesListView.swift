//
//  RepositoriesListView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoriesListView: View {
    
    @ObservedObject var viewModel: RepositoriesListViewModel
    
    @EnvironmentObject var favoriteListViewModel: FavoritesListViewModel
    
    @State private var selectedRepository: Repository?
    
    @State private var path: [Repository] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            content
                .onChange(of: viewModel.repositoryGrouping) {
                    viewModel.regroup()
                }
                .navigationTitle("GitHub Repositories")
                .navigationDestination(item: $selectedRepository) { repository in
                    RepositoryDetailsView(
                        repository: repository,
                        isFavorite: Binding(
                            get: {
                                viewModel.isFavorite(repository)
                            }, set: { newValue in
                                if newValue != viewModel.isFavorite(repository) {
                                    viewModel.toggleFavorite(for: repository)
                                }
                            })
                    )
                }
                .task {
                    if case .loaded = viewModel.state { return }
                    await viewModel.loadData()
                }
                .onAppear {
                    viewModel.setFavoritesViewModel(favoriteListViewModel)
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                LoadingView(message: "Loading GitHub repositories...")
            case .loaded(let list, let grouped):
                if viewModel.repositoryGrouping == .none {
                    flatList(list)
                } else {
                    groupedList(grouped)
                }
            case .failed(let error):
                ErrorView(message: error.localizedDescription, retryAction: {
                    Task {
                        await viewModel.loadData()
                    }
                })
            }
        }
    }
    
    @ViewBuilder
    private func flatList(_ repositories: [Repository]) -> some View {
        List(repositories, id: \.id) { repository in
            Button {
                selectedRepository = repository
            } label: {
                RepositoriesListItemView(
                    repository: repository,
                    isFavorite: viewModel.isFavorite(repository),
                    favoriteHandler: {
                        viewModel.toggleFavorite(for: repository)
                    }
                )
            }
            .onAppear {
                if let index = repositories.firstIndex(where: { $0.id == repository.id }),
                   index >= repositories.count - 5 {
                    Task {
                        await viewModel.loadData()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func groupedList(_ grouped: [String: [Repository]]) -> some View {
        List {
            let sortedKeys = grouped.keys.sorted()
            ForEach(sortedKeys, id: \.self) { key in
                Section(header: Text(key)) {
                    let repositories = grouped[key] ?? []
                    ForEach(repositories, id: \.id) { repository in
                        Button {
                            selectedRepository = repository
                        } label: {
                            RepositoriesListItemView(
                                repository: repository,
                                isFavorite: viewModel.isFavorite(repository),
                                favoriteHandler: {
                                    viewModel.toggleFavorite(for: repository)
                                }
                            )
                        }
                        .onAppear {
                            if key == sortedKeys.last,
                               let index = repositories.firstIndex(where: { $0.id == repository.id }),
                               index >= repositories.count - 5 {
                                Task {
                                    await viewModel.loadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
