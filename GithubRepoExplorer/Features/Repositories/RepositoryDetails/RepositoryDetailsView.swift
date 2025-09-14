//
//  RepositoryDetailsView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoryDetailsView: View {
    
    let repository: Repository
    
    @Binding var isFavorite: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ownerInfoSection
                nameSection
                descriptionSection
                favoriteButtonSection
                detailsSection
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(repository.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var ownerInfoSection: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: repository.owner.avatar_url)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(repository.owner.login)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(repository.owner.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Text(repository.name)
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var descriptionSection: some View {
        if let description = repository.description, !description.isEmpty {
            Text(description)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.triangle.branch")
                    .foregroundColor(.accentColor)
                Text(repository.forkStatusTitle)
            }
            
            if let urlStr = repository.html_url, let url = URL(string: urlStr) {
                Link(destination: url) {
                    Label("Open on GitHub", systemImage: "link")
                        .foregroundColor(.blue)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }
    
    @ViewBuilder
    private var favoriteButtonSection: some View {
        Button(action: { isFavorite.toggle() }) {
            Label(
                isFavorite ? "Remove from Favorites" : "Add to Favorites",
                systemImage: isFavorite ? "heart.fill" : "heart"
            )
            .foregroundColor(isFavorite ? .red : .accentColor)
            .font(.headline)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}
