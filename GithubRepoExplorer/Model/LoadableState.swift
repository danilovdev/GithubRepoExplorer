//
//  LoadableState.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 12.09.2025.
//

enum LoadableState<Data, GroupedData> {
    case loading
    case loaded(Data, GroupedData)
    case failed(Error)
}
