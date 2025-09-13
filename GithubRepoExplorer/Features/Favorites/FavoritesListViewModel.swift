//
//  FavoritesListViewModel.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

final class FavoritesListViewModel: ObservableObject {
    
    private let favoritesStorage: FavoritesStorage
    
    @Published var favorites: [Repository] = []
    
    init(favoritesStorage: FavoritesStorage) {
        self.favoritesStorage = favoritesStorage
        favorites = favoritesStorage.loadFavorites()
    }
    
    func toggleFavorite(for repository: Repository) {
        if let index = favorites.firstIndex(where: { $0.id == repository.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(repository)
        }

        favoritesStorage.saveFavorites(favorites)
    }
    
    func isFavorite(_ repository: Repository) -> Bool {
        favorites.contains(where: { $0.id == repository.id })
    }
}
