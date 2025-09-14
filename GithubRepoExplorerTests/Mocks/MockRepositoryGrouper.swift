//
//  MockRepositoryGrouper.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 15.09.2025.
//

import Foundation

@testable import GithubRepoExplorer

final class MockRepositoryGrouper: RepositoryGrouper {
    
    var receivedRepositories: [Repository]?
    
    var receivedGrouping: RepositoryGrouping?
    
    var mockResult: [String : [Repository]] = [:]
    
    override func group(_ repositories: [Repository], by grouping: RepositoryGrouping) -> [String : [Repository]] {
        receivedRepositories = repositories
        receivedGrouping = grouping
        return mockResult
    }
}
