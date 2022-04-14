//
//  CustomToggle.swift
//  
//
//  Created by Nick Sarno on 4/13/22.
//

import SwiftUI

@available(iOS 14, *)
/// Customizable Toggle.
public struct CustomToggle: View {
    
    @Binding var isOn: Bool
    let width: CGFloat
    let pinColor: Color
    let backgroundColor: Color
    let haptic: HapticOption
    
    public init(
        isOn: Binding<Bool>,
        width: CGFloat = 64,
        pinColor: Color = .blue,
        backgroundColor: Color = Color.gray.opacity(0.3),
        haptic: HapticOption = .never) {
            self._isOn = isOn
            self.width = width
            self.pinColor = pinColor
            self.backgroundColor = backgroundColor
            self.haptic = haptic
    }
    
    public var body: some View {
        Circle()
            .fill(pinColor)
            .aspectRatio(1, contentMode: .fit)
            .padding(width * 0.06)
            .frame(width: width, height: width / 1.8, alignment: isOn ? .trailing : .leading)
            .withBackground(color: backgroundColor, cornerRadius: 100)
            .animation(.spring(), value: isOn)
            .withHaptic(option: haptic, onChangeOf: isOn)
            .onTapGesture {
                isOn.toggle()
            }
    }
}

@available(iOS 14, *)
struct CustomToggle_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isOn: Bool = false
        var body: some View {
            VStack {
                CustomToggle(isOn: $isOn)
                CustomToggle(isOn: $isOn, width: 100, pinColor: .gray, backgroundColor: .black, haptic: .selection)
                CustomToggle(isOn: $isOn, pinColor: .white, backgroundColor: isOn ? .green : .gray.opacity(0.3))
                CustomToggle(isOn: $isOn, pinColor: isOn ? .red : .white, backgroundColor: isOn ? .blue : .gray.opacity(0.3))
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
