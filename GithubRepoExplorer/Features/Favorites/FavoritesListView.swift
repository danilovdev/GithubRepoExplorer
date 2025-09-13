//
//  FavoritesListView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

struct FavoritesListView: View {
    
    @ObservedObject var viewModel: FavoritesListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favorites) { repository in
                    RepositoriesListItemView(
                        repository: repository,
                        isFavorite: viewModel.isFavorite(repository),
                        favoriteHandler: {
                            viewModel.toggleFavorite(for: repository)
                        }
                    )
                }
            }
            .navigationBarTitle("Favorites")
        }
    }
}
