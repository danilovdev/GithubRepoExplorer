//
//  RepositoriesListItemView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoriesListItemView: View {
    
    let repository: Repository
    let isFavorite: Bool
    let favoriteHandler: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: repository.owner.avatar_url)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(repository.name)
                    .font(.headline)
                Text(repository.owner.login)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(repository.owner.html_url)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    favoriteHandler()
                }
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .scaleEffect(isFavorite ? 1.5 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isFavorite)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
