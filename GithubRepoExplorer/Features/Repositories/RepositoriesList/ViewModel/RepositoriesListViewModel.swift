//
//  RepositoriesListViewModel.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import Foundation
import SwiftUI

@MainActor
final class RepositoriesListViewModel: ObservableObject {
    
    @AppStorage("repositoryGrouping") var repositoryGrouping: RepositoryGrouping = .none
    
    @Published var state: LoadableState<[Repository], [String: [Repository]]> = .loading
    
    private var favoritesViewModel: FavoritesListViewModel?
    
    private let repositoriesService: RepositoriesService
    
    private let repositoryGrouper: RepositoryGrouper
    
    private var nextPageURL: URL? = URL(string: "https://api.github.com/repositories")
    
    private var isLoadingNextPage: Bool = false
    
    init(
        repositoriesService: RepositoriesService,
        repositoryGrouper: RepositoryGrouper
    ) {
        self.repositoriesService = repositoriesService
        self.repositoryGrouper = repositoryGrouper
    }
    
    func loadData() async {
        guard !isLoadingNextPage, let url = nextPageURL else { return }
        isLoadingNextPage = true
        
        if isFirstLoad {
            state = .loading
        }
        
        do {
            let paginatedResponse = try await repositoriesService.loadRepositories(url: url)
            let newRepositories = paginatedResponse.data
            switch state {
            case .loaded(let existing, _):
                let existingIds = Set(existing.map(\.id))
                let newUniqueRepos = newRepositories.filter { !existingIds.contains($0.id) }
                let allRepositories = existing + newUniqueRepos
                let grouped = repositoryGrouper.group(allRepositories, by: repositoryGrouping)
                state = .loaded(allRepositories, grouped)
                nextPageURL = paginatedResponse.nextPageURL
            default:
                state = .loaded(newRepositories, repositoryGrouper.group(newRepositories, by: repositoryGrouping))
            }
        } catch {
            state = .failed(error)
        }
        
        isLoadingNextPage = false
    }
    
    func toggleFavorite(for repository: Repository) {
        favoritesViewModel?.toggleFavorite(for: repository)
    }
    
    func isFavorite(_ repository: Repository) -> Bool {
        favoritesViewModel?.isFavorite(repository) ?? false
    }
    
    func setFavoritesViewModel(_ viewModel: FavoritesListViewModel) {
        favoritesViewModel = viewModel
    }
    
    private var isFirstLoad: Bool {
        if case .loaded(let data, _) = state, !data.isEmpty {
            return false
        }
        return true
    }
    
    func regroup() {
        if case .loaded(let data, _) = state {
            let grouped = repositoryGrouper.group(data, by: repositoryGrouping)
            state = .loaded(data, grouped)
        }
    }
}
