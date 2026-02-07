//
//  View+EXT.swift
//  SwiftfulUI
//
//  Created by Nick Sarno.
//
import SwiftUI

extension View {

    public func any() -> AnyView {
        AnyView(self)
    }

    public func tappableBackground() -> some View {
        background(Color.black.opacity(0.001))
    }

    public func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
    }

    @ViewBuilder
    public func ifSatisfiesCondition(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

}

extension View {

    public func callToActionButton(
        font: Font = .headline,
        foregroundColor: Color = .white,
        backgroundColor: Color = .accentColor,
        verticalPadding: CGFloat? = 12,
        horizontalPadding: CGFloat? = nil,
        cornerRadius: CGFloat = 16
    ) -> some View {
        self
            .font(font)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, horizontalPadding)
            .frame(maxWidth: horizontalPadding == nil ? .infinity : nil)
            .padding(.vertical, verticalPadding)
            .frame(maxHeight: verticalPadding == nil ? .infinity : nil)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }

}
