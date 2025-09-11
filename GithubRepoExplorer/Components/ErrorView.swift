//
//  ErrorView.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

import SwiftUI

struct ErrorView: View {
    
    var title: String = "We got error here!"
    var message: String = "Please try again later."
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.red)
                .foregroundColor(.red)
            
            Text(title)
                .font(.title2)
                .bold()
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if let retryAction = retryAction {
                Button("Retry", action: retryAction)
                    .padding(.top, 8)
            }
        }
        .padding(16)
    }
}
