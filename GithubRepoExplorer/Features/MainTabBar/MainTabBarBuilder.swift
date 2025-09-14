//
//  MainTabBarBuilder.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

struct MainTabBarBuilder {
    
    @MainActor
    static func build() -> some View {
        let favoritesViewModel = FavoritesListViewModel(favoritesStorage: FavoritesStorageImpl())
        let repositoryGrouper = RepositoryGrouper()
        let networkService = NetworkServiceImpl(session: URLSession.shared)
        let paginatedNetworkService = PaginatedNetworkServiceImpl(networkService: networkService)
        let repositoriesService = RepositoriesServiceImpl(networkService: paginatedNetworkService)
        let repositoriesViewModel = RepositoriesListViewModel(
            repositoriesService: repositoriesService,
            repositoryGrouper: repositoryGrouper
        )
        return MainTabBarView(repositoriesViewModel: repositoriesViewModel)
            .environmentObject(favoritesViewModel)
    }
}
