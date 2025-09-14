//
//  RepositoriesListView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoriesListView: View {
    
    @ObservedObject var viewModel: RepositoriesListViewModel
    
    @State private var selectedRepository: Repository?
    
    @State private var path: [Repository] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                switch viewModel.state {
                case .loading:
                    LoadingView(message: "Loading GitHub repositories...")
                case .loaded(let repositories):
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
                            .onAppear {
                                if repository.id == repositories.last?.id {
                                    Task {
                                        await viewModel.loadData()
                                    }
                                }
                            }
                        }
                    }
                case .failed(let error):
                    ErrorView(message: error.localizedDescription, retryAction: {
                        Task {
                            await viewModel.loadData()
                        }
                    })
                }
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
                await viewModel.loadData()
            }
        }
    }
    
    private var groupedList: some View {
        List {
            ForEach(viewModel.groupedRepositories.keys.sorted(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(viewModel.groupedRepositories[key] ?? [], id: \.id) { repository in
                        Button {
                            path.append(repository)
                        } label: {
                            RepositoriesListItemView(
                                repository: repository,
                                isFavorite: viewModel.isFavorite(repository),
                                favoriteHandler: {
                                    viewModel.toggleFavorite(for: repository)
                                }
                            )
//                            .onAppear {
//                                if repository.id == repositories.last?.id {
//                                    Task {
//                                        await viewModel.loadData()
//                                    }
//                                }
//                            }
                        }
                    }
                }
            }
        }
    }
}
