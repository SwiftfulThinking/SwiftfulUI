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

struct AppView: View {
    
    let showView1: Bool
    let view1: () -> any View
    let view2: () -> any View
    
    var body: some View {
//        ZStack {
//            ZStack {
                if showView1 {
                    AnyView(view1())
                }
//            }
//            .zIndex(showView1 ? 2 : 1)
            
//            ZStack {
                if !showView1 {
                    AnyView(view2())
                }
//            }
//            .zIndex(showView1 ? 1 : 2)
//        }
    }
}


// var data: [(String, [(String, [String])])]

struct AnyRecursiveModel<Value:Identifiable>: Hashable, Identifiable {
    var id: AnyHashable
    var value: Value
    var children: [AnyRecursiveModel<Value>]?

//    init<Model: HasRecursiveChildren>(_ model: Model) where Model.Value == Value {
//        self.id = AnyHashable(model.id)
//        self.value = model.value
//        self.children = model.children?.map(AnyRecursiveModel.init)
//    }
    
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

//func asAnyRecursiveModel<T>(projectId: String) -> [AnyRecursiveModel<T>] {
//    convertToRecursiveObject
//}

func convertToRecursiveModel<T>(_ items: [T]) -> [AnyRecursiveModel<T>] where T : Identifiable {
    guard let first = items.first else { return [] }
    
    var result: [AnyRecursiveModel<T>] = []
    var remainingItems: [T] = items
    
    var object = AnyRecursiveModel(value: first)
    
    remainingItems.remove(at: 0)
    let children = convertToRecursiveModel(remainingItems)
    if !children.isEmpty {
        object.children = children
    }
    
    result.append(object)
    return result
}

//func convertToRecursiveModel<T>(_ items: [T]) -> [AnyRecursiveModel<T>] where T : Identifiable {
//    
//    var result: [AnyRecursiveModel<T>] = []
//    var remainingItems: [T] = items
//    
//    for item in items {
//        var object = AnyRecursiveModel(value: item)
//        
//        remainingItems.remove(at: 0)
//        let children = convertToRecursiveModel(remainingItems)
//        if !children.isEmpty {
//            object.children = children
//        }
//        
//        result.append(object)
//    }
//    
//    return result
//}




//struct AnyRecursiveRow<T:Identifiable, Row:View, Header:View>: View {
//    
//    let items: [AnyRecursiveModel<T>]
//    @ViewBuilder let row: (AnyRecursiveModel<T>) -> Row
//    @ViewBuilder let header: () -> Header
//    
//    var body: some View {
//        DisclosureGroup {
//            ForEach(items) { item in
//                row(item)
//                    .listRowSeparator(.hidden)
//
//

struct AnyRecursiveView<T:Identifiable>: View {
    
    let selection: T?
    let items: [T]
    let recursiveItems: [AnyRecursiveModel<T>]
    let view: (T?) -> any View
    
    init(selection: T?, items: [T], view: @escaping (T?) -> any View) {
        self.selection = selection
        self.items = items
        self.recursiveItems = convertToRecursiveModel(items)
        self.view = view
    }

    var body: some View {
        AppView(
            showView1: selection?.id == items.first?.id,
            view1: {
                AnyView(view(items.first))
            },
            view2: {
                RecursiveView(
                    selection: selection,
                    items: recursiveItems.first?.children ?? [],
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
        AppView(
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

//struct PreviewView<T:Identifiable>: View {
//    
//    let selection: AnyRecursiveModel<T>?
//    let items: [AnyRecursiveModel<T>]
//    let view: (AnyRecursiveModel<T>?) -> any View
//    
//    var body: some View {
//        ZStack {
//            ForEach(items, id: \.self) { item in
//                AppView(
//                    showView1: selection?.value.id == item.value.id,
//                    view1: {
//                        AnyView(view(item))
//                    },
//                    view2: {
//                        if let children = item.children {
//                            PreviewView(
//                                selection: selection,
//                                items: item.children ?? [],
//                                view: { value in
//    //                                AnyView(view(item))
//                                    Color.orange
//                                }
//                            )
//                        } else {
//                            Text("err: \(item.children?.count ?? 998)")
//                        }
////                        if let children = item.children {
////                        ZStack {
////                            Color.blue
//                            
//                            
////                            PreviewView(
////                                selection: selection,
////                                items: item.children ?? [],
////                                view: { _ in
////                                    AnyView(view(item))
////                                }
////                            )
////                        }
////                        } else {
////                            Text("Dead:: \(item.children?.count ?? 987)")
////                        }
//                    }
//                )
//            }
//        }
//    }
//}






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
//        Item(text: "four"),
    ]
//    @State var questions = convertToRecursiveModel([
//        Item(text: "one"),
//        Item(text: "two"),
//        Item(text: "three"),
////        Item(text: "four"),
//    ])
    
    var body: some View {
        ZStack {
//            ForEach(questions, id: \.self) { value in
//                HStack {
//                    Text(value.value.text)
//                    Text("\(value.children?.count ?? 999)")
//                }
//                
//                ForEach(value.children!, id: \.self) { vx in
//                    HStack {
//                        Text(vx.value.text)
//                        Text("\(vx.children?.count ?? 999)")
//                    }
//                }
//            }
            
            AnyRecursiveView(selection: selection, items: questions) { value in
                
//            }
//            
//            PreviewView(selection: questions[showIndex], items: questions) { value in
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
//                    .id(value?.id)
            }
        }
        .animation(.smooth, value: selection?.id)
        
//        PreviewView(items: questions, view: { value in
//            
//        }
//        )
//        PreviewView(showIndex: showIndex, data: [
//            ("one", ["two", ["three", ["Four"]]])
//        ], view1: { data in
//            Text(data ?? "nah")
//        }
//        )
//        PreviewView(showIndex: showIndex, view1: {
//            Rectangle()
//                .fill(Color.red)
//                .transition(AnyTransition.move(edge: .leading))
//        })
        .onTapGesture {
            //            showSignIn.toggle()
            
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
