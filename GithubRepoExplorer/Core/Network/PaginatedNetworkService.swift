//
//  PaginatedNetworkService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import Foundation

protocol PaginatedNetworkService {
    
    func loadPaginated<Data: Decodable>(_ url: URL) async throws -> PaginatedResponse<Data>
}

final class PaginatedNetworkServiceImpl: PaginatedNetworkService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadPaginated<Data: Decodable>(_ url: URL) async throws -> PaginatedResponse<Data> {
        let response: NetworkResponse<Data> = try await networkService.load(url)
        let nextPageURL = parseNextPageURL(from: response.httpResponse)
        return PaginatedResponse(data: response.value, nextPageURL: nextPageURL)
    }
}

private extension PaginatedNetworkServiceImpl {
    
    func parseNextPageURL(from response: HTTPURLResponse) -> URL? {
        guard let linkHeader = response.value(forHTTPHeaderField: "Link") else { return nil }
        let links = linkHeader.components(separatedBy: ",")
        for link in links {
            let parts = link.components(separatedBy: ";")
            guard parts.count == 2 else { continue }
            let urlPart = parts[0].trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
            let relPart = parts[1].trimmingCharacters(in: .whitespaces)
            if relPart == "rel=\"next\"" {
                return URL(string: urlPart)
            }
        }
        return nil
    }
}
