//
//  FavoritesStorage.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

protocol FavoritesStorage {
    func loadFavorites() -> Set<Int>
    func saveFavorites(_ favoritesIds: Set<Int>)
}

final class FavoritesStorageImpl: FavoritesStorage {
    
    private let defaultsKey = "FavoritesIds"
    
    func loadFavorites() -> Set<Int> {
        if let savedIds = UserDefaults.standard.array(forKey: defaultsKey) as? [Int] {
            return Set(savedIds)
        } else {
            return []
        }
    }
    
    func saveFavorites(_ favoritesIds: Set<Int>) {
        UserDefaults.standard.set(Array(favoritesIds), forKey: defaultsKey)
    }
}
