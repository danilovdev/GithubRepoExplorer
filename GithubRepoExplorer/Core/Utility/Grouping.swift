//
//  Grouping.swift
//  GithubRepoExplorer
//
//  Created by Aleksei Danilov on 14.09.2025.
//

struct Grouping<Key: Hashable, Element> {
    let keyPath: KeyPath<Element, Key>
    
    func group(_ elements: [Element]) -> [Key: [Element]] {
        var groupedElements: [Key: [Element]] = [:]
        
        for element in elements {
            let keyValue = element[keyPath: keyPath]
            if groupedElements[keyValue] == nil {
                groupedElements[keyValue] = [element]
            } else {
                groupedElements[keyValue]?.append(element)
            }
        }
        
        return groupedElements
    }
}
