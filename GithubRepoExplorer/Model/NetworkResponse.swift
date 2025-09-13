//
//  NetworkResponse.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 13.09.2025.
//

import Foundation

struct NetworkResponse<Data> {
    let value: Data
    let httpResponse: HTTPURLResponse
}
