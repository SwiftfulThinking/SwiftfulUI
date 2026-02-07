//
//  OnFirstTaskViewModifier.swift
//  SwiftfulUI
//
//  Created by Nick Sarno.
//

import Foundation
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
struct OnFirstTaskViewModifier: ViewModifier {

    @State private var didAppear: Bool = false
    let priority: TaskPriority
    let action: @MainActor @Sendable () async -> Void

    func body(content: Content) -> some View {
        content
            .task {
                guard !didAppear else { return }
                didAppear = true
                await action()
            }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public extension View {

    func onFirstTask(priority: TaskPriority = .userInitiated, action: @MainActor @Sendable @escaping () async -> Void) -> some View {
        modifier(OnFirstTaskViewModifier(priority: priority, action: action))
    }
}
