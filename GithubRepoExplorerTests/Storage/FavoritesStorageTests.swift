//
//  FavoritesStorageTests.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import Foundation
import XCTest
@testable import GithubRepoExplorer

final class FavoritesStorageTests: XCTestCase {
    
    private var mockUserDefaults: MockUserDefaults!
    
    private var storage: FavoritesStorageImpl!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        storage = FavoritesStorageImpl(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        mockUserDefaults = nil
        storage = nil
        super.tearDown()
    }
    
    func testLoadFavorites_Empty() {
        let favorites = storage.loadFavorites()
        XCTAssertEqual(favorites, [])
        
    }
    
    func testSaveAndLoadFavorites() {
        let favorite = Repository(
            id: 1,
            name: "Repo",
            full_name: "Full Repo",
            private: false,
            fork: false,
            owner: Owner(
                login: "Demo Owner",
                id: 1,
                avatar_url: "",
                url: "",
                html_url: "",
                type: .user
            )
        )
        
        storage.saveFavorites([favorite])
        let loaded = storage.loadFavorites()
        XCTAssertEqual(loaded, [favorite])
    }
    
    func testLoadFavorites_InvalidData() {
        mockUserDefaults.set("Random string", forKey: "FavoriteRepositories")
        
        let favorites = storage.loadFavorites()
        XCTAssertEqual(favorites, [])
    }
}
