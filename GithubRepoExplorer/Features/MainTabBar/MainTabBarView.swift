//
//  MainTabBarView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

struct MainTabBarView: View {
    
    @StateObject private var favoritesViewModel = FavoritesListViewModel(favoritesStorage: FavoritesStorageImpl())
    
    var body: some View {
        TabView {
            RepositoriesListModuleBuilder.build(favoritesViewModel: favoritesViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavoritesModuleBuilder.build(favoritesViewModel: favoritesViewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
        }
    }
}
