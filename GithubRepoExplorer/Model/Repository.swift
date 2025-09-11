//
//  Repository.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
    let full_name: String
    let `private`: Bool
    let owner: Owner
}
