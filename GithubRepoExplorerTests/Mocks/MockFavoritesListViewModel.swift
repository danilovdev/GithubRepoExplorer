//
//  MockFavoritesListViewModel.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 15.09.2025.
//

@testable import GithubRepoExplorer

final class MockFavoritesListViewModel: FavoritesListViewModel {
    
    var toggled: [Repository] = []
    
    var favoriteIds: Set<Int> = []
    
    init() {
        super.init(favoritesStorage: MockFavoritesStorage())
    }
    
    override func toggleFavorite(for repository: Repository) {
        toggled.append(repository)
        
        if favoriteIds.contains(repository.id) {
            favoriteIds.remove(repository.id)
        } else {
            favoriteIds.insert(repository.id)
        }
    }
    
    override func isFavorite(_ repository: Repository) -> Bool {
        favoriteIds.contains(repository.id)
    }
}
