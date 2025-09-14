//
//  FavoritesStorage.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

protocol UserDefaultsProtocol {
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

protocol FavoritesStorage {
    func loadFavorites() -> [Repository]
    func saveFavorites(_ favorites: [Repository])
}

final class FavoritesStorageImpl: FavoritesStorage {
    
    private let defaultsKey = "FavoriteRepositories"
    
    private let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func loadFavorites() -> [Repository] {
        guard let data = userDefaults.data(forKey: defaultsKey) else { return [] }
        return (try? JSONDecoder().decode([Repository].self, from: data)) ?? []
    }
    
    func saveFavorites(_ favorites: [Repository]) {
        let data = try? JSONEncoder().encode(favorites)
        userDefaults.set(data, forKey: defaultsKey)
    }
}
