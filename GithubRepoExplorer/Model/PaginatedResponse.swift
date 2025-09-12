//
//  PaginatedResponse.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 13.09.2025.
//

import Foundation

struct PaginatedResponse<Data> {
    let data: Data
    let nextPageURL: URL?
}
