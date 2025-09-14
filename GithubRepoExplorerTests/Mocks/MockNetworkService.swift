//
//  MockNetworkService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import Foundation

@testable import GithubRepoExplorer

final class MockNetworkService: NetworkService {
    
    var mockResponse: Any?
    
    var mockError: Error?
    
    func load<Data: Decodable>(_ url: URL) async throws -> NetworkResponse<Data> {
        if let mockError {
            throw mockError
        }
        guard let response = mockResponse as? NetworkResponse<Data> else {
            fatalError("MockNetworkService mockResponse is not set")
        }
        return response
    }
}
