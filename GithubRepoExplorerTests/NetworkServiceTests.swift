//
//  Untitled.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import XCTest
@testable import GithubRepoExplorer

final class NetworkServiceTests: XCTestCase {
    private var service: NetworkServiceImpl!
    private var mockSession: MockURLSession!
    private let testURL = URL(string: "https://www.example.com")!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        service = NetworkServiceImpl(session: mockSession)
    }
    
    override func tearDown() {
        mockSession = nil
        service = nil
        super.tearDown()
    }
    
    func testLoad_Success() async throws {
        let expectedModel = TestModel(id: 1, name: "Test")
        mockSession.mockData = try JSONEncoder().encode(expectedModel)
        mockSession.mockResponse = HTTPURLResponse(
            url: testURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let result: NetworkResponse<TestModel> = try await service.load(testURL)
        XCTAssertEqual(result.value, expectedModel)
        XCTAssertEqual(result.httpResponse.statusCode, 200)
    }
    
    func testLoad_DecodingError() async {
        mockSession.mockData = Data("not json".utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: testURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            _ = try await service.load(testURL) as NetworkResponse<TestModel>
            XCTFail("Expected decoding error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testLoad_RateLimitExceeded() async throws {
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: testURL,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            _ = try await service.load(testURL) as NetworkResponse<TestModel>
            XCTFail("Expected rate limit error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .rateLimit)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testLoad_HTTPError() async throws {
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: testURL,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            _ = try await service.load(testURL) as NetworkResponse<TestModel>
            XCTFail("Expected http error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .httpError(code: 500))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testLoad_InvalidResponse() async throws {
        mockSession.mockData = Data()
        mockSession.mockResponse = URLResponse(
            url: testURL,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        do {
            _ = try await service.load(testURL) as NetworkResponse<TestModel>
            XCTFail("Expected invalid response error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testLoad_UnknownError() async throws {
        mockSession.mockData = Data()
        mockSession.mockError = NSError(domain: "test", code: 1, userInfo: nil)
        
        do {
            _ = try await service.load(testURL) as NetworkResponse<TestModel>
            XCTFail("Expected unknown error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unknown)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}
