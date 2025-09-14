//
//  MockFavoritesStorage.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

@testable import GithubRepoExplorer

final class MockFavoritesStorage: FavoritesStorage {
    
    var mockFavorites: [Repository] = []
    
    var savedFavoritesCallParameters: [Repository]?
    
    var loadFavoritesCallCount = 0
    
    var saveFavoritesCallCount = 0
        
    func loadFavorites() -> [Repository] {
        loadFavoritesCallCount += 1
        return mockFavorites
    }
    
    func saveFavorites(_ favorites: [Repository]) {
        saveFavoritesCallCount += 1
        savedFavoritesCallParameters = favorites
        mockFavorites = favorites
    }
}
