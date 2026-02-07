//
//  NonLazyHGrid.swift
//  SwiftfulUI
//
//  Created by Nick Sarno on 1/13/24.
//

import Foundation
import SwiftUI

public struct NonLazyHGrid<T, Content:View>: View {
    var rows: Int = 2
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat = 8
    let items: [T]
    @ViewBuilder var content: (T?) -> Content
    
    public init(rows: Int = 2, alignment: VerticalAlignment = .center, spacing: CGFloat = 10, items: [T], @ViewBuilder content: @escaping (T?) -> Content) {
        self.rows = rows
        self.alignment = alignment
        self.spacing = spacing
        self.items = items
        self.content = content
    }

    private var columnCount: Int {
        Int((Double(items.count) / Double(rows)).rounded(.up))
    }
        
    public var body: some View {
        HStack(alignment: alignment, spacing: spacing, content: {
            ForEach(Array(0..<columnCount), id: \.self) { rowIndex in
                VStack(alignment: .leading, spacing: spacing, content: {
                    ForEach(Array(0..<rows), id: \.self) { columnIndex in
                        let index = (rowIndex * rows) + columnIndex
                        if index < items.count {
                            content(items[index])
                        } else {
                            content(nil)
                        }
                    }
                })
            }
        })
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 40) {
            NonLazyHGrid(
                rows: 2,
                alignment: .center,
                spacing: 16,
                items: ["one", "two", "three", "four", "five"],
                content: { item in
                    Text(item ?? "")
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .opacity(item == nil ? 0 : 1)
                }
            )
            
            NonLazyHGrid(
                rows: 4,
                alignment: .top,
                spacing: 16,
                items: ["one", "two", "three", "four", "five"],
                content: { item in
                    Text(item ?? "")
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .opacity(item == nil ? 0 : 1)
                }
            )
            
            NonLazyHGrid(
                rows: 2,
                alignment: .center,
                spacing: 16,
                items: ["one", "two", "three", "four", "five"],
                content: { item in
                    if let item {
                        Text(item)
                            .background(Color.blue)
                    }
                }
            )
            .background(Color.orange)
            
            NonLazyHGrid(
                rows: 4,
                alignment: .center,
                spacing: 16,
                items: ["one", "two", "three", "four", "five"],
                content: { item in
                    if let item {
                        Text(item)
                            .background(Color.blue)
                    }
                }
            )
            .background(Color.orange)
            
            NonLazyHGrid(
                rows: 4,
                alignment: .center,
                spacing: 16,
                items: ["one", "two", "three", "four", "five"],
                content: { item in
                    if let item {
                        Text(item)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                    }
                }
            )
            
            NonLazyHGrid(
                rows: 3,
                alignment: .center,
                spacing: 16,
                items: ["one", "two", "three", "four", "five"],
                content: { item in
                    Text(item ?? "")
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .opacity(item == nil ? 0 : 1)
                }
            )
            
            NonLazyHGrid(
                rows: 3,
                alignment: .center,
                spacing: 16,
                items: ["one", "two", "three", "four", "five"],
                content: { item in
                    if let item {
                        Text(item)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                    }
                }
            )
        }
    }
}
