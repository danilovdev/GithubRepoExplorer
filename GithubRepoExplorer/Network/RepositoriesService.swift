//
//  RepositoriesService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

protocol RepositoriesService {
    func loadRepositories() async throws -> [Repository]
}

struct RepositoriesServiceImpl: RepositoriesService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadRepositories() async throws -> [Repository] {
        guard let url = URL(string: "https://api.github.com/repositories") else {
            throw NetworkError.invalidURL
        }
        return try await networkService.load(url)
    }
}
