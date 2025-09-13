//
//  FavoritesStorage.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

protocol FavoritesStorage {
    func loadFavorites() -> [Repository]
    func saveFavorites(_ favoritesIds: [Repository])
}

final class FavoritesStorageImpl: FavoritesStorage {
    
    private let defaultsKey = "FavoriteRepositories"
    
    func loadFavorites() -> [Repository] {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else { return [] }
        return (try? JSONDecoder().decode([Repository].self, from: data)) ?? []
    }
    
    func saveFavorites(_ favorites: [Repository]) {
        let data = try? JSONEncoder().encode(favorites)
        UserDefaults.standard.set(data, forKey: defaultsKey)
    }
}
