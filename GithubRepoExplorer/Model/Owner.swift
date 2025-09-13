//
//  Owner.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

enum OwnerType: String, Codable, Hashable {
    case user = "User"
    case organization = "Organization"
}

struct Owner: Codable, Hashable {
    let login: String
    let id: Int
    let avatar_url: String
    let url: String
    let html_url: String
    let type: OwnerType
}
