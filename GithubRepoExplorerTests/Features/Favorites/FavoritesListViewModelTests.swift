//
//  FavoritesListViewModelTests.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import XCTest
@testable import GithubRepoExplorer

final class FavoritesListViewModelTests: XCTestCase {
    
    private var mockStorage: MockFavoritesStorage!
    
    private var viewModel: FavoritesListViewModel!
    
    private let fav1 = Repository(
        id: 1,
        name: "Repo 1",
        full_name: "Repo1 Full Name",
        private: false,
        fork: false,
        owner: Owner(
            login: "Owner 1",
            id: 1,
            avatar_url: "",
            url: "",
            html_url: "",
            type: .user
        )
    )
    
    private let fav2 = Repository(
        id: 2,
        name: "Repo 2",
        full_name: "Repo2 Full Name",
        private: false,
        fork: false,
        owner: Owner(
            login: "Owner 2",
            id: 1,
            avatar_url: "",
            url: "",
            html_url: "",
            type: .user
        )
    )
    
    override func setUp() {
        super.setUp()
        mockStorage = MockFavoritesStorage()
        viewModel = FavoritesListViewModel(favoritesStorage: mockStorage)
    }
    
    override func tearDown() {
        mockStorage = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testInit_loadFavorites() {
        let mockStorage = MockFavoritesStorage()
        mockStorage.mockFavorites = [fav1, fav2]
        let viewModel = FavoritesListViewModel(favoritesStorage: mockStorage)
        XCTAssertEqual(viewModel.favorites, [fav1, fav2])
        XCTAssertEqual(mockStorage.loadFavoritesCallCount, 1)
    }
    
    func testToggleFavorite_AddIfPresent() {
        viewModel.toggleFavorite(for: fav1)
        XCTAssertTrue(viewModel.isFavorite(fav1))
        XCTAssertEqual(mockStorage.savedFavoritesCallParameters, [fav1])
        XCTAssertEqual(mockStorage.saveFavoritesCallCount, 1)
    }
    
    func testToggleFavorite_RemoveIfPresent() {
        viewModel.favorites = [fav1]
        viewModel.toggleFavorite(for: fav1)
        XCTAssertFalse(viewModel.isFavorite(fav1))
        XCTAssertEqual(mockStorage.savedFavoritesCallParameters, [])
        XCTAssertEqual(mockStorage.saveFavoritesCallCount, 1)
    }
    
    func testIsFavorite_ReturnTrueIfPresent() {
        viewModel.favorites = [fav1]
        XCTAssertTrue(viewModel.isFavorite(fav1))
        XCTAssertEqual(mockStorage.loadFavoritesCallCount, 1)
    }
    
    func testIsFavorite_ReturnFalseIfNotPresent() {
        viewModel.favorites = [fav1]
        XCTAssertFalse(viewModel.isFavorite(fav2))
        XCTAssertEqual(mockStorage.loadFavoritesCallCount, 1)
    }
}
