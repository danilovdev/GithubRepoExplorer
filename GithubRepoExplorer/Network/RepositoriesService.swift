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
    func loadRepositories() async throws -> [Repository] {
        let url = URL(string: "https://api.github.com/repositories")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            fatalError("Failed to load repositories")
        }
        return try JSONDecoder().decode([Repository].self, from: data)  
    }
}
