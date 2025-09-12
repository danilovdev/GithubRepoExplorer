//
//  NetworkService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 13.09.2025.
//

import Foundation

protocol NetworkService {
    func load<T: Decodable>(_ url: URL) async throws -> PaginatedResponse<T>
}

final class NetworkServiceImpl: NetworkService {
    func load<T>(_ url: URL) async throws -> PaginatedResponse<T> where T : Decodable {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    let nextPageURL = parseNextPageURL(from: httpResponse)
                    return PaginatedResponse(data: decoded, nextPageURL: nextPageURL)
                } catch {
                    throw NetworkError.decodingError
                }
            case 403:
                throw NetworkError.rateLimit
            default:
                throw NetworkError.httpError(code: httpResponse.statusCode)
            }
        } catch {
            throw NetworkError.unknown
        }
    }
    
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
