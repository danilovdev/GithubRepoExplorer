//
//  NetworkService.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 13.09.2025.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

protocol NetworkService {
    func load<Data: Decodable>(_ url: URL) async throws -> NetworkResponse<Data>
}

final class NetworkServiceImpl: NetworkService {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func load<Data: Decodable>(_ url: URL) async throws -> NetworkResponse<Data> {
        do {
            let (data, response) = try await session.data(from: url)
            
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
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown
        }
    }
}
