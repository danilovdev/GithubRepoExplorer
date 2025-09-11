//
//  RepositoriesListItemView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct RepositoriesListItemView: View {
    
    let repository: Repository
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: repository.owner.avatar_url)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
        }
    }
}
