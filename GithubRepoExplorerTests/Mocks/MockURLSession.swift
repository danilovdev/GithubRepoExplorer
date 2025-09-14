//
//  MockURLSession.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import Foundation
@testable import GithubRepoExplorer

final class MockURLSession: URLSessionProtocol {
    
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let mockError {
            throw mockError
        }
        
        guard let mockData, let mockResponse else {
            fatalError("Mock data and response must be set.")
        }
        
        return (mockData, mockResponse)
    }
}
