//
//  NetworkService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 13.09.2025.
//

import Foundation

protocol NetworkService {
    func load<Data: Decodable>(_ url: URL) async throws -> NetworkResponse<Data>
}

final class NetworkServiceImpl: NetworkService {
    func load<Data: Decodable>(_ url: URL) async throws -> NetworkResponse<Data> {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                do {
                    let decoded = try JSONDecoder().decode(Data.self, from: data)
                    return NetworkResponse(value: decoded, httpResponse: httpResponse)
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
