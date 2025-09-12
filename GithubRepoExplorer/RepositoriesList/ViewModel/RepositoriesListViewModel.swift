//
//  RepositoriesListViewModel.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

@MainActor
final class RepositoriesListViewModel: ObservableObject {
    
    @Published var state: LoadableState<[Repository]> = .loading
    
    @Published var favorites: Set<Int> = []
    
    private let repositoriesService: RepositoriesService
    
    private let favoritesStorage: FavoritesStorage
    
    
    init(
        repositoriesService: RepositoriesService,
        favoritesStorage: FavoritesStorage
    ) {
        self.repositoriesService = repositoriesService
        self.favoritesStorage = favoritesStorage
        self.favorites = favoritesStorage.loadFavorites()
    }
    
    func loadData() async {
        state = .loading
        do {
            let repositories = try await repositoriesService.loadRepositories()
            state = .loaded(repositories)
        } catch {
            state = .failed(error)
        }
    }
    
    func toggleFavorite(for repository: Repository) {
        if favorites.contains(repository.id) {
            favorites.remove(repository.id)
        } else {
            favorites.insert(repository.id)
        }
        favoritesStorage.saveFavorites(favorites)
    }
    
    func isFavorite(_ repository: Repository) -> Bool {
        favorites.contains(repository.id)
    }
}
