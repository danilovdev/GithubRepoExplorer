//
//  RepositoryGrouping.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

enum RepositoryGrouping: String, CaseIterable, Identifiable {
    case none
    case isFork
    case ownerType
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .none:
            return "No Grouping"
        case .isFork:
            return "Is fork"
        case .ownerType:
            return "Owner Type"
        }
    }
}
