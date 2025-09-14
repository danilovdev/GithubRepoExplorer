//
//  GroupingTests.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

import XCTest
@testable import GithubRepoExplorer

final class GroupingTests: XCTestCase {
    
    func testGroupByCategory() {
        let items = [
            TestGroupModel(id: 1, category: "A", value: 10),
            TestGroupModel(id: 2, category: "B", value: 10),
            TestGroupModel(id: 3, category: "A", value: 20),
            TestGroupModel(id: 4, category: "C", value: 20),
            TestGroupModel(id: 5, category: "B", value: 30),
        ]
        
        let grouping = Grouping<String, TestGroupModel>(keyPath: \.category)
        let result = grouping.group(items)
        
        XCTAssertEqual(result["A"], [items[0], items[2]])
        XCTAssertEqual(result["B"], [items[1], items[4]])
        XCTAssertEqual(result["C"], [items[3]])
        XCTAssertEqual(result.count, 3)
    }
    
    func testGroupByValue() {
        let items = [
            TestGroupModel(id: 1, category: "Model 1", value: 10),
            TestGroupModel(id: 2, category: "Model 2", value: 10),
            TestGroupModel(id: 3, category: "Model 3", value: 20),
            TestGroupModel(id: 4, category: "Model 4", value: 20),
            TestGroupModel(id: 5, category: "Model 5", value: 30),
        ]
        
        let grouping = Grouping<Int, TestGroupModel>(keyPath: \.value)
        let result = grouping.group(items)
        
        XCTAssertEqual(result[10], [items[0], items[1]])
        XCTAssertEqual(result[20], [items[2], items[3]])
        XCTAssertEqual(result[30], [items[4]])
        XCTAssertEqual(result.count, 3)
    }
}

private struct TestGroupModel: Equatable {
    let id: Int
    let category: String
    let value: Int
}
