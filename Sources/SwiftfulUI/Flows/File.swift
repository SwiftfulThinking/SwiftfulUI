//
//  File.swift
//  
//
//  Created by Nick Sarno on 11/11/23.
//

import Foundation
import SwiftUI


// ParentView - The implementation
// AnyRecursiveView - Takes an array and makes it recursive
// RecursiveView - Takes recursive data and displays it
// AppView - 2 items in a ZStack
// View - has the transition

//func eachFirst<FirstT: Collection, each T: Collection>(_ firstItem: FirstT, _ item: repeat each T) -> (FirstT.Element?, repeat (each T).Element?) {
//    return (firstItem.first, repeat (each item).first)
//}
//static func buildBlock<each Content>(_ content: repeat each Content) -> TupleView<(repeat each Content)> where repeat each Content : View

/// A view displays one of two views based on a Boolean
struct AnyConditionalView: View {
    
    let showView1: Bool
    let view1: () -> any View
    let view2: () -> any View
    
    var body: some View {
        if showView1 {
            AnyView(view1())
        }
        if !showView1 {
            AnyView(view2())
        }
    }
}

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
    func asAnyRecursiveModel() throws -> AnyRecursiveModel<Element> {
        let items = self
        
        guard let first = items.first else { 
            throw URLError(.dataNotAllowed)
        }
        
        var remainingItems: [Element] = items
        
        var object = AnyRecursiveModel(value: first)
        
        remainingItems.remove(at: 0)
        let children = remainingItems.asArrayOfAnyRecursiveModel()
        if !children.isEmpty {
            object.children = children
        }
        
        return object
    }
    
    private func asArrayOfAnyRecursiveModel() -> [AnyRecursiveModel<Element>] {
        let items = self
        
        guard let first = items.first else { return [] }
        
        var result: [AnyRecursiveModel<Element>] = []
        var remainingItems: [Element] = items
        
        var object = AnyRecursiveModel(value: first)
        
        remainingItems.remove(at: 0)
        let children = remainingItems.asArrayOfAnyRecursiveModel()
        if !children.isEmpty {
            object.children = children
        }
        
        result.append(object)
        return result
    }

}


struct AnyRecursiveView<T:Identifiable>: View {
    
    let selection: T?
    let items: [T]
    let recursiveItem: AnyRecursiveModel<T>?
    let view: (T?) -> any View
    
    init(selection: T?, items: [T], view: @escaping (T?) -> any View) {
        self.selection = selection
        self.items = items
        self.recursiveItem = try? items.asAnyRecursiveModel()
        self.view = view
    }

    var body: some View {
        AnyConditionalView(
            showView1: selection?.id == items.first?.id,
            view1: {
                AnyView(view(items.first))
            },
            view2: {
                RecursiveView(
                    selection: selection,
                    items: recursiveItem?.children ?? [],
                    view: { value in
                        AnyView(view(value?.value))
                    }
                )
            }
        )
    }
}

struct RecursiveView<T:Identifiable>: View {
    
    let selection: T?
    let items: [AnyRecursiveModel<T>]
    let view: (AnyRecursiveModel<T>?) -> any View
    
    var body: some View {
        AnyConditionalView(
            showView1: selection?.id == items.first?.id,
            view1: {
                AnyView(view(items.first))
            },
            view2: {
                if let children = items.first?.children {
                    RecursiveView(
                        selection: selection,
                        items: children,
                        view: { value in
                            AnyView(view(value))
                        }
                    )
                } else {
                    EmptyView()
                }
            }
        )
    }
}

struct Item: Identifiable {
    var id: String {
        text
    }
    let text: String
}

typealias AnyRecursiveItem = AnyRecursiveModel<Item>

struct AnotherView: View {
    
    @State private var selection: Item? = nil
    @State var questions = [
        Item(text: "one"),
        Item(text: "two"),
        Item(text: "three"),
        Item(text: "four"),
    ]
//    @State var questions = convertToRecursiveModel([
//        Item(text: "one"),
//        Item(text: "two"),
//        Item(text: "three"),
////        Item(text: "four"),
//    ])
    
    @State private var showOnboarding: Bool = false
    
    var body: some View {
        ZStack {
//            ForEach(0..<10) { x in
//            }
//            AnyRecursiveView(selection: x, items: 0..<10) { x in
//                
//            }
            
            
            AnyRecursiveView(selection: selection, items: questions) { value in
                Rectangle()
                    .fill(
                        value?.text == "one" ? Color.red :
                        value?.text == "two" ? Color.blue :
                        value?.text == "three" ? Color.orange :
                        value?.text == "four" ? Color.green :
                        Color.yellow
                    )
                    .overlay(
                        Text(value?.text ?? "nah")
                    )
                    .transition(AnyTransition.move(edge: value?.id == questions.first?.id ? .leading : .trailing))
            }
        }
        .animation(.linear, value: selection?.id)
        .onTapGesture {
            if let selection, let index = questions.firstIndex(where: { $0.id == selection.id }),
               questions.indices.contains(index + 1) {
                self.selection = questions[index + 1]
            } else {
                selection = questions.first
            }
        }
        .onAppear {
            selection = questions.first
        }
    }
}

#Preview {
    AnotherView()
}
