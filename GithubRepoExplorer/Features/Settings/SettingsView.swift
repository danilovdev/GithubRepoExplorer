//
//  Settings.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("repositoryGrouping") var repositoryGrouping: RepositoryGrouping = .none
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Repositories List")) {
                    Picker(
                        selection: $repositoryGrouping,
                        label: Text("Grouping")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    ) {
                        ForEach(RepositoryGrouping.allCases, id: \.self) { grouping in
                            Text(grouping.displayName)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
