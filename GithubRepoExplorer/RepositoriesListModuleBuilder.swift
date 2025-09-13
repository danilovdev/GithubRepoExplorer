//
//  RepositoriesListModuleBuilder.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

final class RepositoriesListModuleBuilder {
    
    @MainActor
    static func build() -> some View {
        let networkService = NetworkServiceImpl()
        let paginatedNetworkService = PaginatedNetworkServiceImpl(networkService: networkService)
        let repositoriesService = RepositoriesServiceImpl(networkService: paginatedNetworkService)
        let favoritesStorage = FavoritesStorageImpl()
        let viewModel = RepositoriesListViewModel(
            repositoriesService: repositoriesService,
            favoritesStorage: favoritesStorage
        )
        let view = RepositoriesListView(viewModel: viewModel)
        return view
    }
}
