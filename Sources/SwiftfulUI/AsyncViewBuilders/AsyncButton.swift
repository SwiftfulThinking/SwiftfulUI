//
//  AsyncButton.swift
//
//
//  Created by Nick Sarno on 11/12/23.
//

import Foundation
import SwiftUI

// credit: Ricky Stone

public struct AsyncButton<Label: View>: View {
    let action: () async -> Void
    let label: (Bool) -> Label
    @State private var task: Task<(), Never>? = nil
    
    public init(action: @escaping () async -> Void, label: @escaping (Bool) -> Label) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(action: {
            task = Task { @MainActor in
                await action()
                task = nil
            }
        }, label: {
            label(task != nil)
        })
        .onDisappear {
            task?.cancel()
            task = nil
        }
    }
}

#Preview("AsyncButton") {
    AsyncButton {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    } label: { isPerformingAction in
        ZStack {
            if isPerformingAction {
                if #available(iOS 14.0, *) {
                    ProgressView()
                }
            }
            
            Text("Hello, world!")
                .opacity(isPerformingAction ? 0 : 1)
        }
        .foregroundColor(.white)
        .font(.headline)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
        .disabled(isPerformingAction)
    }
    .padding()
}
