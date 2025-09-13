//
//  FavoritesModuleBuilder.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

final class FavoritesModuleBuilder {
    static func build(favoritesViewModel: FavoritesListViewModel) -> some View {
        return FavoritesListView(viewModel: favoritesViewModel)
    }
}
