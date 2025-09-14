//
//  MainTabBarView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

struct MainTabBarView: View {
    
    @ObservedObject var repositoriesViewModel: RepositoriesListViewModel
    
    var body: some View {
        TabView {
            RepositoriesListView(viewModel: repositoriesViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavoritesListView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
