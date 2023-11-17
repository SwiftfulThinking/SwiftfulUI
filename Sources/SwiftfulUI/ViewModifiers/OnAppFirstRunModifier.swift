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
                if UserDefaults.standard.bool(forKey: "appHasBeenLaunchedOnce") == false {
                    action()
                    UserDefaults.standard.set(true, forKey: "appHasBeenLaunchedOnce")
                }
            }
    }
}

extension View {
    public func onAppFirstRun(perform action: @MainActor @escaping () -> Void) -> some View {
        modifier(OnAppFirstRunModifier(action: action))
    }
}
