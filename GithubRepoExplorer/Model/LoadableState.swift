//
//  LoadableState.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

enum LoadableState<Data> {
    case loading
    case loaded(Data)
    case failed(Error)
}
