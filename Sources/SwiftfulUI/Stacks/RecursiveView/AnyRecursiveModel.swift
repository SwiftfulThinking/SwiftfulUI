//
//  File.swift
//  
//
//  Created by Nick Sarno on 11/12/23.
//

import Foundation

/// A data model that contains itself, and a child array of it's own Type
struct AnyRecursiveModel<Value:Identifiable>: Hashable, Identifiable {
    var id: AnyHashable
    var value: Value
    var children: [AnyRecursiveModel<Value>]?
    
    init(value: Value) {
        self.id = value.id
        self.value = value
        self.children = nil
    }

    static func == (lhs: AnyRecursiveModel<Value>, rhs: AnyRecursiveModel<Value>) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    mutating func appendingChild(_ child: AnyRecursiveModel<Value>) {
        children = (children ?? []) + [child]
    }
}

extension Array where Element : Identifiable {
    
    /// Convert any array into AnyRecursiveModel, where Value is the first element in the Array
    ///
    /// For exampel:
    ///
    /// - let array = [1,2,3, 4, 5, 6]
    /// - let newValue = array.asAnyRecursiveModel()
    /// - then newValue will be:
    /// - let newValue [(1, [(2, [(3, [(4, [(5, [])])])])])]
    ///
    func asAnyRecursiveModelWithDepthOfOne() throws -> AnyRecursiveModel<Element> {
        let items = self
        
        guard let first = items.first else {
            throw URLError(.dataNotAllowed)
        }
        
        var remainingItems: [Element] = items
        
        var object = AnyRecursiveModel(value: first)
        
        remainingItems.remove(at: 0)
        let children = remainingItems.asArrayOfAnyRecursiveModelWithDepthOfOne()
        if !children.isEmpty {
            object.children = children
        }
        
        return object
    }
    
    private func asArrayOfAnyRecursiveModelWithDepthOfOne() -> [AnyRecursiveModel<Element>] {
        let items = self
        
        guard let first = items.first else { return [] }
        
        var result: [AnyRecursiveModel<Element>] = []
        var remainingItems: [Element] = items
        
        var object = AnyRecursiveModel(value: first)
        
        remainingItems.remove(at: 0)
        let children = remainingItems.asArrayOfAnyRecursiveModelWithDepthOfOne()
        if !children.isEmpty {
            object.children = children
        }
        
        result.append(object)
        return result
    }

}
