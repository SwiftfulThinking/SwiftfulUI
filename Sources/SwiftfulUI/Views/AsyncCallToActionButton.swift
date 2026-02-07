//
//  AsyncCallToActionButton.swift
//  SwiftfulUI
//
//  Created by Nick Sarno.
//

import SwiftUI

public struct AsyncCallToActionButton: View {

    var isLoading: Bool = false
    var title: String = "Save"
    var action: () -> Void

    public init(isLoading: Bool = false, title: String = "Save", action: @escaping () -> Void) {
        self.isLoading = isLoading
        self.title = title
        self.action = action
    }

    public var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text(title)
            }
        }
        .callToActionButton()
        .asButton(.press) {
            action()
        }
        .disabled(isLoading)
    }
}

private struct PreviewView: View {

    @State private var isLoading: Bool = false

    var body: some View {
        AsyncCallToActionButton(
            isLoading: isLoading,
            title: "Finish",
            action: {
                isLoading = true

                Task {
                    try? await Task.sleep(for: .seconds(3))
                    isLoading = false
                }
            }
        )
    }
}

#Preview {
    PreviewView()
        .padding()
}
