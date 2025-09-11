//
//  RepositoriesListView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoriesListView: View {
    
    @StateObject var viewModel: RepositoriesListViewModel
    
    var body: some View {
        VStack {
            List(viewModel.repositories) { repository in
                    RepositoriesListItemView(repository: repository)
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}
