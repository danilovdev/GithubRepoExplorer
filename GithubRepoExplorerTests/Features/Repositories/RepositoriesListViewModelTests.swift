//
//  RepositoriesListViewModelTests.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 15.09.2025.
//

import XCTest

@testable import GithubRepoExplorer

@MainActor
final class RepositoriesListViewModelTests: XCTestCase {
    
    private var mockService: MockRepositoriesService!
    
    private var mockGrouper: MockRepositoryGrouper!
    
    private var viewModel: RepositoriesListViewModel!
    
    override func setUp() {
        super.setUp()
        mockService = MockRepositoriesService()
        mockGrouper = MockRepositoryGrouper()
        viewModel = RepositoriesListViewModel(repositoriesService: mockService, repositoryGrouper: mockGrouper)
    }
    
    override func tearDown() {
        mockService = nil
        mockGrouper = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadData_SuccessFirstPage() async {
        mockService.mockResult = .success(PaginatedResponse(data: [repository1, repository2], nextPageURL: nil))
        mockGrouper.mockResult = ["All": [repository1, repository2]]
        
        await viewModel.loadData()
        
        if case .loaded(let repositories, let grouped) = viewModel.state {
            XCTAssertEqual(mockService.callCount, 1)
            XCTAssertEqual(repositories, [repository1, repository2])
            XCTAssertEqual(grouped, ["All": [repository1, repository2]])
        } else {
            XCTFail("Expected loaded state")
        }
    }
    
    func testLoadData_SuccessPagination_AppendUnique() async {
        mockService.mockResult = .success(PaginatedResponse(data: [repository1], nextPageURL: URL(string: "https:www.google.com/next")))
        mockGrouper.mockResult = ["All": [repository1]]
        await viewModel.loadData()
        
        mockService.mockResult = .success(PaginatedResponse(data: [repository1, repository2], nextPageURL: nil))
        mockGrouper.mockResult = ["All": [repository1, repository2]]
        await viewModel.loadData()
        
        if case .loaded(let repositories, let grouped) = viewModel.state {
            XCTAssertEqual(mockService.callCount, 2)
            XCTAssertEqual(repositories, [repository1, repository2])
            XCTAssertEqual(mockService.receivedURL, URL(string: "https://api.github.com/repositories")!)
            XCTAssertEqual(grouped, ["All": [repository1, repository2]])
        } else {
            XCTFail("Expected loaded state")
        }
    }
    
    func testLoadData_Failure() async {
        let mockError: Error = NSError(domain: "", code: 0, userInfo: nil)
        mockService.mockResult = .failure(mockError)
        
        await viewModel.loadData()
        
        if case .failed(let error) = viewModel.state {
            XCTAssertEqual(error as NSError, mockError as NSError)
            XCTAssertEqual(mockService.callCount, 1)
        } else {
            XCTFail("Expected failed state")
        }
    }
    
    func testRegroup_UpdatesGrouped() async {
        mockService.mockResult = .success(PaginatedResponse(data: [repository1], nextPageURL: nil))
        mockGrouper.mockResult = ["All": [repository1]]
        await viewModel.loadData()
        
        viewModel.repositoryGrouping = .ownerType
        mockGrouper.mockResult = ["User": [repository1]]
        viewModel.regroup()
        
        if case .loaded(_, let grouped) = viewModel.state {
            XCTAssertEqual(grouped, ["User": [repository1]])
            XCTAssertEqual(mockGrouper.receivedGrouping, .ownerType)
            XCTAssertEqual(mockGrouper.receivedRepositories, [repository1])
            XCTAssertEqual(mockService.callCount, 1)
        } else {
            XCTFail("Expected loaded state")
        }
    }
    
    func testToggleFavorite_DelegateToFavoritesViewModel() {
        let mockFavoritesListViewModel = MockFavoritesListViewModel()
        viewModel.setFavoritesViewModel(mockFavoritesListViewModel)
        viewModel.toggleFavorite(for: repository1)
        XCTAssertEqual(mockFavoritesListViewModel.toggled, [repository1])
    }
    
    func testIsFavorite_DelegateToFavoritesViewModel() {
        let mockFavoritesListViewModel = MockFavoritesListViewModel()
        mockFavoritesListViewModel.favoriteIds = Set([repository1.id])
        viewModel.setFavoritesViewModel(mockFavoritesListViewModel)
        XCTAssertTrue(viewModel.isFavorite(repository1))
        XCTAssertFalse(viewModel.isFavorite(repository2))
    }
}

extension RepositoriesListViewModelTests {
    private var repository1: Repository {
        Repository(
            id: 1,
            name: "Repo 1",
            full_name: "Repo 1 Full Name",
            private: false,
            fork: false,
            owner: Owner(
                login: "login",
                id: 1,
                avatar_url: "",
                url: "",
                html_url: "",
                type: .user
            ),
            html_url: nil,
            description: nil
        )
    }
    
    private var repository2: Repository {
        Repository(
            id: 2,
            name: "Repo 2",
            full_name: "Repo 2 Full Name",
            private: false,
            fork: true,
            owner: Owner(
                login: "login",
                id: 1,
                avatar_url: "",
                url: "",
                html_url: "",
                type: .organization
            ),
            html_url: nil,
            description: nil
        )
    }
}
