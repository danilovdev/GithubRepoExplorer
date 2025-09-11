//
//  RepositoriesListViewModel.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation

@MainActor
final class RepositoriesListViewModel: ObservableObject {
    
    @Published var state: LoadableState<[Repository]> = .loading
    
    private let repositoriesService: RepositoriesService
    
    init(repositoriesService: RepositoriesService) {
        self.repositoriesService = repositoriesService
    }
    
    func loadData() async {
        state = .loading
        do {
            let repositories = try await repositoriesService.loadRepositories()
            state = .loaded(repositories)
        } catch {
            print("Error")
        }
        
    }
}
