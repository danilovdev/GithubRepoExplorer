//
//  NetworkError\.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 13.09.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(code: Int)
    case rateLimit
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .rateLimit:
            return "API rate limit exceeded"
        case .decodingError:
            return "Failed to decode data"
        case .unknown:
            return "Unknown error"
        case .httpError(let code):
            return "HTTP error \(code)"
        }
    }
}
