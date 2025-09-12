//
//  RepositoriesService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

protocol RepositoriesService {
    func loadRepositories(url: URL?) async throws -> PaginatedResponse<[Repository]>
}

struct RepositoriesServiceImpl: RepositoriesService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadRepositories(url: URL?) async throws -> PaginatedResponse<[Repository]> {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        return try await networkService.load(url)
    }
}
