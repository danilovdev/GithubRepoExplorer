//
//  NetworkService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 13.09.2025.
//

import Foundation

protocol NetworkService {
    func load<T: Decodable>(_ url: URL) async throws -> T
}

final class NetworkServiceImpl: NetworkService {
    func load<T>(_ url: URL) async throws -> T where T : Decodable {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    return decoded
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
}
