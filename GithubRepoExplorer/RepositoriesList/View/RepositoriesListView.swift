//
//  RepositoriesListView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoriesListView: View {
    
    @ObservedObject var viewModel: RepositoriesListViewModel
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                LoadingView(message: "Loading GitHub repositories...")
            case .loaded(let repositories):
                List(repositories, id: \.id) { repository in
                        RepositoriesListItemView(
                            repository: repository,
                            isFavorite: viewModel.isFavorite(repository),
                            favoriteHandler: {
                                viewModel.toggleFavorite(for: repository)
                            }
                        )
                }
            case .failed(let error):
                ErrorView(message: error.localizedDescription)
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}
