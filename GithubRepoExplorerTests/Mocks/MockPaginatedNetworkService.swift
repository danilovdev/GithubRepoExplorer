//
//  MockPaginatedNetworkService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import Foundation

@testable import GithubRepoExplorer

final class MockPaginatedNetworkService: PaginatedNetworkService {
    
    var mockResult: Result<PaginatedResponse<[Repository]>, Error>?
    
    func loadPaginated<Data: Decodable>(_ url: URL) async throws -> PaginatedResponse<Data> {
        if let mockResult {
            switch mockResult {
            case .success(let response):
                return response as! PaginatedResponse<Data>
            case .failure(let error):
                throw error
            }
        }
        fatalError("MockPaginatedNetworkService mockResult is not configured")
    }
}
