//
//  CustomToggle.swift
//  
//
//  Created by Nick Sarno on 4/13/22.
//

import SwiftUI

@available(iOS 14, *)
/// Customizable Toggle.
struct CustomToggle: View {
    
    @Binding var isOn: Bool
    let width: CGFloat
    let accentColor: Color
    let backgroundColor: Color
    let haptic: HapticOption
    
    init(
        isOn: Binding<Bool>,
        width: CGFloat = 64,
        accentColor: Color = .blue,
        backgroundColor: Color = Color.gray.opacity(0.3),
        haptic: HapticOption = .never) {
            self._isOn = isOn
            self.width = width
            self.accentColor = accentColor
            self.backgroundColor = backgroundColor
            self.haptic = haptic
    }
    
    var body: some View {
        Circle()
            .fill(accentColor)
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
                CustomToggle(isOn: $isOn, accentColor: .white, backgroundColor: isOn ? .green : .gray.opacity(0.3))
                CustomToggle(isOn: $isOn, accentColor: isOn ? .red : .white, backgroundColor: isOn ? .blue : .gray.opacity(0.3))
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
