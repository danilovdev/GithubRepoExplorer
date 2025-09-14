//
//  RepositoriesServiceTests.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import XCTest
@testable import GithubRepoExplorer

final class RepositoriesServiceTests: XCTestCase {
    
    private var service: RepositoriesServiceImpl!
    
    private var mockNetworkService: MockPaginatedNetworkService!
    
    private let testURL = URL(string: "https://www.example.com")!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockPaginatedNetworkService()
        service = RepositoriesServiceImpl(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        service = nil
        super.tearDown()
    }
    
    func testLoadRepositories_Success() async throws {
        let repo = Repository(
            id: 1,
            name: "Test",
            full_name: "Full Test",
            private: false,
            fork: false,
            owner: Owner(
                login: "Test Owner",
                id: 1,
                avatar_url: "",
                url: "",
                html_url: "",
                type: .user
            )
        )
        let expectedNextPageURL = try XCTUnwrap(URL(string: "https://www.example.com/next/365"))
        let expectedResponse = PaginatedResponse(data: [repo], nextPageURL: expectedNextPageURL)
        mockNetworkService.mockResult = .success(expectedResponse)
        
        let result = try await service.loadRepositories(url: testURL)
        
        XCTAssertEqual(result.data, expectedResponse.data)
        XCTAssertEqual(result.nextPageURL, expectedResponse.nextPageURL)
    }
    
    func testLoadRepositories_InvalidURL() async throws {
        do {
            _ = try await service.loadRepositories(url: nil)
            XCTFail("Expected to throw an invalid URL error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testLoadRepositories_NetworkError() async throws {
        mockNetworkService.mockResult = .failure(NetworkError.rateLimit)
        
        do {
            _ = try await service.loadRepositories(url: testURL)
            XCTFail("Expected to throw an rateLimit error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .rateLimit)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
