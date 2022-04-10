//
//  TabBarDefaultView.swift
//  Catalog
//
//  Created by Nick Sarno on 11/14/21.
//

import SwiftUI


/// Customizable TabBar
///
///  ```swift
///  // 'Default' style
///  TabBarDefaultView(
///     selection: $selection,
///     tabs: tabs,
///     accentColor: .blue,
///     defaultColor: .gray,
///     backgroundColor: .white,
///     font: .caption,
///     iconSize: 20,
///     spacing: 6,
///     insetPadding: 10,
///     outerPadding: 0,
///     cornerRadius: 0)
///
///  // 'Floating' style
///  TabBarDefaultView(
///     selection: $selection,
///     tabs: tabs,
///     accentColor: .blue,
///     defaultColor: .gray,
///     backgroundColor: .white,
///     font: .caption,
///     iconSize: 20,
///     spacing: 6,
///     insetPadding: 12,
///     outerPadding: 12,
///     cornerRadius: 30,
///     shadowRadius: 8)
///  ```
public struct TabBarDefaultView: View {
    
    @Binding var selection: TabBarItem
    let tabs: [TabBarItem]
    let accentColor: Color
    let defaultColor: Color
    let backgroundColor: Color?
    let font: Font
    let iconSize: CGFloat
    let spacing: CGFloat
    let insetPadding: CGFloat
    let outerPadding: CGFloat
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    public init(
        selection: Binding<TabBarItem>,
        tabs: [TabBarItem],
        accentColor: Color = .blue,
        defaultColor: Color = .gray,
        backgroundColor: Color? = nil,
        font: Font = .caption,
        iconSize: CGFloat = 20,
        spacing: CGFloat = 4,
        insetPadding: CGFloat = 10,
        outerPadding: CGFloat = 0,
        cornerRadius: CGFloat = 0,
        shadowRadius: CGFloat = 0
    ) {
        self._selection = selection
        self.tabs = tabs
        self.accentColor = accentColor
        self.defaultColor = defaultColor
        self.backgroundColor = backgroundColor
        self.font = font
        self.iconSize = iconSize
        self.spacing = spacing
        self.insetPadding = insetPadding
        self.outerPadding = outerPadding
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab)
                    .background(Color.black.opacity(0.001))
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(.horizontal, insetPadding)
        .background(
            ZStack {
                if let backgroundColor = backgroundColor {
                    backgroundColor
                        .shadow(radius: shadowRadius)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.clear
                }
            }
        )
        .cornerRadiusIfNeeded(cornerRadius: cornerRadius)
        .padding(outerPadding)
    }

    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
    
}

extension View {
    
    @ViewBuilder func cornerRadiusIfNeeded(cornerRadius: CGFloat) -> some View {
        if cornerRadius > 0 {
            self
                .cornerRadius(cornerRadius)
        } else {
            self
        }
    }
    
}

struct TabBarDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarViewBuilder_Previews.previews
    }
}

private extension TabBarDefaultView {
    
    private func tabView(_ tab: TabBarItem) -> some View {
        VStack(spacing: spacing) {
            if let icon = tab.iconName {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
            }
            if let image = tab.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
            }
            if let title = tab.title {
                Text(title)
            }
        }
        .font(font)
        .foregroundColor(selection == tab ? accentColor : defaultColor)
        .frame(maxWidth: .infinity)
        .padding(.vertical, insetPadding)
        .overlay(
            ZStack {
                if let count = tab.badgeCount, count > 0 {
                    Text("\(count)")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(6)
                        .background(accentColor)
                        .clipShape(Circle())
                        .offset(x: iconSize * 0.9, y: -iconSize * 0.9)
                }
            }
        )
    }
    
}
