//
//  AnyRecursiveView.swift
//  
//
//  Created by Nick Sarno on 11/12/23.
//

import Foundation
import SwiftUI

// Notes:
// ParentView - The implementation
// AnyRecursiveView - Takes an array and makes it recursive
// RecursiveView - Takes recursive data and displays it
// AppView - 2 items in a ZStack
// View - has the transition

public typealias LazyZStack = AnyRecursiveView

public struct AnyRecursiveView<T:Identifiable>: View {
    
    let selection: T?
    let items: [T]
    let recursiveItem: AnyRecursiveModel<T>?
    let view: (T?) -> any View
    
    public init(selection: T?, items: [T], view: @escaping (T?) -> any View) {
        self.selection = selection
        self.items = items
        self.recursiveItem = try? items.asAnyRecursiveModelWithDepthOfOne()
        self.view = view
    }

    public init(selection: T?, items: Range<T>, view: @escaping (T?) -> any View) where T : IntegerIdentifiable {
        self.selection = selection
        let array: [T] = Array(range: items)
        self.items = array
        self.recursiveItem = try? array.asAnyRecursiveModelWithDepthOfOne()
        self.view = view
    }

    public var body: some View {
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


// MARK: IntegerIdentifiable

public protocol IntegerIdentifiable: Identifiable where ID == Int {
    var id: Int { get }
    init(id: Int)
}

extension Int: IntegerIdentifiable {
    public var id: Int {
        self
    }
    public init(id: Int) {
        self = id
    }
}

extension Array {
    init(range: Range<Element>) where Element : Identifiable, Element : IntegerIdentifiable {
        self.init((range.lowerBound.id...range.upperBound.id).map { id in
            Element(id: id)
        })
    }
}

// MARK: PREVIEW

fileprivate struct PreviewView: View {
    struct Item: Identifiable {
        var id: String {
            text
        }
        let text: String
    }
    
    @State private var selection: Item? = nil
    @State var questions = [
        Item(text: "one"),
        Item(text: "two"),
        Item(text: "three"),
        Item(text: "four"),
    ]
    
    var selectedIndex: Int {
        questions.firstIndex(where: { $0.id == selection?.id }) ?? 0
    }
        
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Example using Int
                AnyRecursiveView(selection: selectedIndex, items: 0..<4) { value in
                    Rectangle()
                        .fill(
                            value == 1 ? Color.red :
                            value == 2 ? Color.blue :
                            value == 3 ? Color.orange :
                            Color.yellow
                        )
                        .overlay(
                            Text("\(value ?? 999)")
                        )
                        .transition(AnyTransition.slide)
                }

                // Example using Identifiable
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
                        .transition(AnyTransition.scale)
                }
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
    PreviewView()
}
