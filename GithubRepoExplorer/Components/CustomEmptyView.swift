//
//  CustomEmptyView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

struct CustomEmptyView: View {
    
    let systemImageName: String
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack {
            Image(systemName: systemImageName)
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}
