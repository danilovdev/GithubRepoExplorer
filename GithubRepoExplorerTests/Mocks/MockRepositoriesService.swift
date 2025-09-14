//
//  MockRepositoriesService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 15.09.2025.
//

import Foundation

@testable import GithubRepoExplorer

final class MockRepositoriesService: RepositoriesService {
    
    var receivedURL: URL?
    
    var mockResult: Result<PaginatedResponse<[Repository]>, Error>?
    
    func loadRepositories(url: URL?) async throws -> PaginatedResponse<[Repository]> {
        receivedURL = url
        switch mockResult {
        case .none:
            fatalError("MockRepositoriesService mockResult is not set")
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }
}
