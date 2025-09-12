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
    
    private var nextPageURL: URL? = URL(string: "https://api.github.com/repositories")
    
    private var isLoadingNextPage: Bool = false
    
    init(
        repositoriesService: RepositoriesService,
        favoritesStorage: FavoritesStorage
    ) {
        self.repositoriesService = repositoriesService
        self.favoritesStorage = favoritesStorage
        self.favorites = favoritesStorage.loadFavorites()
    }
    
    func loadData() async {
        guard !isLoadingNextPage, let url = nextPageURL else { return }
        isLoadingNextPage = true
        
        if isFirstLoad {
            state = .loading
        }
        
        do {
            let paginatedResponse = try await repositoriesService.loadRepositories(url: url)
            let newRepositories = paginatedResponse.data
            switch state {
            case .loaded(let existing):
                state = .loaded(existing + newRepositories)
                nextPageURL = paginatedResponse.nextPageURL
            default:
                state = .loaded(newRepositories)
            }
        } catch {
            state = .failed(error)
        }
        
        isLoadingNextPage = false
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
    
    private var isFirstLoad: Bool {
        if case .loaded(let data) = state, !data.isEmpty {
            return false
        }
        return true
    }
}
