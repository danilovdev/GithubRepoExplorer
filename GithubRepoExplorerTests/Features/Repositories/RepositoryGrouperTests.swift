//
//  RepositoryGrouperTests.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import XCTest
@testable import GithubRepoExplorer

final class RepositoryGrouperTests: XCTestCase {
    
    private let repository1 = Repository(
        id: 1,
        name: "Repo 1",
        full_name: "Repo 1 Full Name",
        private: false,
        fork: false,
        owner: Owner(
            login: "login",
            id: 1,
            avatar_url: "",
            url: "",
            html_url: "",
            type: .user
        ),
        html_url: nil,
        description: nil
    )
    
    private let repository2 = Repository(
        id: 1,
        name: "Repo 1",
        full_name: "Repo 1 Full Name",
        private: false,
        fork: true,
        owner: Owner(
            login: "login",
            id: 1,
            avatar_url: "",
            url: "",
            html_url: "",
            type: .organization
        ),
        html_url: nil,
        description: nil
    )
    
    private let repository3 = Repository(
        id: 1,
        name: "Repo 1",
        full_name: "Repo 1 Full Name",
        private: false,
        fork: false,
        owner: Owner(
            login: "login",
            id: 1,
            avatar_url: "",
            url: "",
            html_url: "",
            type: .organization
        ),
        html_url: nil,
        description: nil
    )
    
    func testGroupNone() {
        let grouper = RepositoryGrouper()
        let repositories = [repository1, repository2, repository3]
        let result = grouper.group(repositories, by: .none)
        XCTAssertEqual(result["All"], repositories)
        XCTAssertEqual(result.count, 1)
    }
    
    func testGroupByForkStatus() {
        let grouper = RepositoryGrouper()
        let repositories = [repository1, repository2, repository3]
        let result = grouper.group(repositories, by: .isFork)
        XCTAssertEqual(result["Forked"], [repository2])
        XCTAssertEqual(result["Not forked"], [repository1, repository3])
        XCTAssertEqual(result.count, 2)
    }
    
    func testGroupByOwnerType() {
        let grouper = RepositoryGrouper()
        let repositories = [repository1, repository2, repository3]
        let result = grouper.group(repositories, by: .ownerType)
        XCTAssertEqual(result[OwnerType.user.rawValue], [repository1])
        XCTAssertEqual(result[OwnerType.organization.rawValue], [repository2, repository3])
        XCTAssertEqual(result.count, 2)
    }
}
