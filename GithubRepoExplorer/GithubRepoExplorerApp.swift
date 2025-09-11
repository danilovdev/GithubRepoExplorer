//
//  GithubRepoExplorerApp.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 11.09.2025.
//

import SwiftUI

@main
struct GithubRepoExplorerApp: App {
    var body: some Scene {
        let repositoriesService = RepositoriesServiceImpl()
        let viewModel = RepositoriesListViewModel(repositoriesService: repositoriesService)
        WindowGroup {
            RepositoriesListView(viewModel: viewModel)
        }
    }
}
