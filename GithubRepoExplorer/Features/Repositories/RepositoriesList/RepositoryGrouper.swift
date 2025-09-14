//
//  RepositoryGrouper.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

extension Repository {
    var forkStatusTitle: String {
        if fork {
            return "Forked"
        } else {
            return "Not forked"
        }
    }
}

struct RepositoryGrouper {
    func group(
        _ repositories: [Repository],
        by grouping: RepositoryGrouping
    ) -> [String: [Repository]] {
        switch grouping {
        case .none:
            return ["All": repositories]
        case .ownerType:
            return Grouping<String, Repository>(keyPath: \.owner.type.rawValue).group(repositories)
        case .isFork:
            return Grouping<String, Repository>(keyPath: \.forkStatusTitle).group(repositories)
        }
    }
}
