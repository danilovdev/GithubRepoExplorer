//
//  RepositoriesListView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoriesListView: View {
    
    @StateObject var viewModel: RepositoriesListViewModel
    
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
                            path.append(repository)
                        } label: {
                            RepositoriesListItemView(
                                repository: repository,
                                isFavorite: viewModel.isFavorite(repository),
                                favoriteHandler: {
                                    viewModel.toggleFavorite(for: repository)
                                }
                            )
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
            .navigationDestination(for: Repository.self) { repository in
                RepositoryDetailsView()
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}
