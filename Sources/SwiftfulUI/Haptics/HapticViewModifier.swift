//
//  HapticViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/8/22.
//

import Foundation
import SwiftUI

@available(iOS 14, *)
struct HapticViewModifier<Value : Equatable>: ViewModifier {
    
    let option: Haptics.HapticOption
    let value: Value?
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                Haptics.shared.prepare(option: option)
            })
            .onChange(of: value, perform: { _ in
                Haptics.shared.vibrate(option: option)
            })
    }
    
}

@available(iOS 14, *)
public extension View {
    
    /// Add Haptic support to a View.
    ///
    /// A vibration will occur every onChangeOf the parameter. The generator will be automatically prepared when the view Appears.
    func withHaptic<Value: Equatable>(option: Haptics.HapticOption = .selection, onChangeOf value: Value?) -> some View {
        modifier(HapticViewModifier(option: option, value: value))
    }
    
}

@available(iOS 14, *)
struct HapticViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isOn: String = "false"
        var body: some View {
            Color.red
                .ignoresSafeArea()
                .withHaptic(onChangeOf: isOn)
        }
    }
    static var previews: some View {
        PreviewView()
    }
}

