//
//  NonLazyVGrid.swift
//
//
//  Created by Nick Sarno on 11/12/23.
//

import SwiftUI

public struct NonLazyVGrid<T, Content:View>: View {
    var columns: Int = 2
    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat = 8
    let items: [T]
    @ViewBuilder var content: (T?) -> Content
    
    public init(columns: Int = 2, alignment: HorizontalAlignment = .center, spacing: CGFloat = 10, items: [T], @ViewBuilder content: @escaping (T?) -> Content) {
        self.columns = columns
        self.alignment = alignment
        self.spacing = spacing
        self.items = items
        self.content = content
    }

    private var rowCount: Int {
        Int((Double(items.count) / Double(columns)).rounded(.up))
    }
        
    public var body: some View {
        VStack(alignment: alignment, spacing: spacing, content: {
            ForEach(Array(0..<rowCount), id: \.self) { rowIndex in
                HStack(alignment: .top, spacing: spacing, content: {
                    ForEach(Array(0..<columns), id: \.self) { columnIndex in
                        let index = (rowIndex * columns) + columnIndex
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
            NonLazyVGrid(
                columns: 2,
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
            
            NonLazyVGrid(
                columns: 4,
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
            
            NonLazyVGrid(
                columns: 2,
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
            
            NonLazyVGrid(
                columns: 4,
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
            
            NonLazyVGrid(
                columns: 4,
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
            
            NonLazyVGrid(
                columns: 3,
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
            
            NonLazyVGrid(
                columns: 3,
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
