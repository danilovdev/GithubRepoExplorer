//
//  PaginatedNetworkServiceTests.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import XCTest
@testable import GithubRepoExplorer

final class PaginatedNetworkServiceTests: XCTestCase {
    
    private var mockNetworkService: MockNetworkService!
    private var service: PaginatedNetworkServiceImpl!
    private let testURL = URL(string: "https://www.example.com")!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        service = PaginatedNetworkServiceImpl(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        service = nil
        super.tearDown()
    }
    
    func testLoadPaginated_SuccesWithNextPage() async throws {
        let expectedModel = TestModel(id: 1, name: "Test Model")
        let data = [expectedModel]
        let nextPage = "www.example.com/next"
        let linkHeader = "<\(nextPage)>; rel=\"next\""
        let httpResponse = try XCTUnwrap(HTTPURLResponse(
            url: testURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Link": linkHeader]
        ))
        mockNetworkService.mockResponse = NetworkResponse(value: data, httpResponse: httpResponse)
        
        let result: PaginatedResponse<[TestModel]> = try await service.loadPaginated(testURL)
        XCTAssertEqual(result.data, data)
        XCTAssertEqual(result.nextPageURL, URL(string: nextPage))
    }
    
    func testLoadPaginated_SuccesWithoutNextPage() async throws {
        let expectedModel = TestModel(id: 1, name: "Test Model")
        let data = [expectedModel]
        let httpResponse = try XCTUnwrap(HTTPURLResponse(
            url: testURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
        mockNetworkService.mockResponse = NetworkResponse(value: data, httpResponse: httpResponse)
        
        let result: PaginatedResponse<[TestModel]> = try await service.loadPaginated(testURL)
        XCTAssertEqual(result.data, data)
        XCTAssertNil(result.nextPageURL)
    }
    
    func testLoadPaginated_error() async throws {
        mockNetworkService.mockError = NetworkError.unknown
        do {
            _ = try await service.loadPaginated(testURL) as PaginatedResponse<[TestModel]>
            XCTFail("Expected to throw")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unknown)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
