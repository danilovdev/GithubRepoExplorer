//
//  RepositoriesListModuleBuilder.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

final class RepositoriesListModuleBuilder {
    
    @MainActor
    static func build(favoritesViewModel: FavoritesListViewModel) -> some View {
        let repositoryGrouper = RepositoryGrouper()
        let networkService = NetworkServiceImpl(session: URLSession.shared)
        let paginatedNetworkService = PaginatedNetworkServiceImpl(networkService: networkService)
        let repositoriesService = RepositoriesServiceImpl(networkService: paginatedNetworkService)
        let viewModel = RepositoriesListViewModel(
            repositoriesService: repositoriesService,
            favoritesViewModel: favoritesViewModel,
            repositoryGrouper: repositoryGrouper
        )
        let view = RepositoriesListView(viewModel: viewModel)
        return view
    }
}
