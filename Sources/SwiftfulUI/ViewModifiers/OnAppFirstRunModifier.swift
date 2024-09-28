//
//  OnAppFirstRunModifier.swift
//
//
//  Created by Ricky Stone on 17/11/2023.
//

import SwiftUI

struct OnAppFirstRunModifier: ViewModifier {
    let action: @MainActor () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                FirstRunManager.shared.executeFirstRunAction(action: action)
            }
    }
}

extension View {
    public func onAppFirstRun(perform action: @MainActor @escaping () -> Void) -> some View {
        modifier(OnAppFirstRunModifier(action: action))
    }
}

class FirstRunManager {
    static let shared = FirstRunManager()
    private var hasFirstRunActionExecuted = false

    private init() {}

    func executeFirstRunAction(action: () -> Void) {
        if UserDefaults.standard.bool(forKey: "appHasBeenLaunchedOnce") || hasFirstRunActionExecuted {
            return
        }
        
        action()
        hasFirstRunActionExecuted = true
        UserDefaults.standard.set(true, forKey: "appHasBeenLaunchedOnce")
    }
}

