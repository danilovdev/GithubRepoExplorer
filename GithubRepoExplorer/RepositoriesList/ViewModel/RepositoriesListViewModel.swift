//
//  RepositoriesListViewModel.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

@MainActor
final class RepositoriesListViewModel: ObservableObject {
    
    @Published var repositories: [Repository] = []
    
    @Published var isLoading: Bool = false
    
    private let repositoriesService: RepositoriesService
    
    init(repositoriesService: RepositoriesService) {
        self.repositoriesService = repositoriesService
    }
    
    func loadData() async {
        isLoading = true
        do {
            let respositories = try await repositoriesService.loadRepositories()
            self.repositories = respositories
        } catch {
            print("Error")
        }
        isLoading = false
    }
}
