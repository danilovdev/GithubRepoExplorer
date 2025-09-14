//
//  MockUserDefaults.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import Foundation
@testable import GithubRepoExplorer

final class MockUserDefaults: UserDefaultsProtocol {

    private var storage: [String: Any] = [:]
    
    func data(forKey defaultName: String) -> Data? {
        storage[defaultName] as? Data
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
}
