//
//  CustomProgressBar.swift
//  
//
//  Created by Nick Sarno on 4/13/22.
//

import SwiftUI

@available(iOS 15, *)
/// Customizable progress bar.
public struct CustomProgressBar<T: BinaryFloatingPoint>: View {
        
    let selection: T
    let range: ClosedRange<T>
    let background: AnyShapeStyle
    let foreground: AnyShapeStyle
    let cornerRadius: CGFloat
    let height: CGFloat?
    
    /// Init with AnyShapeStyle (supports gradients)
    public init(
        selection: T,
        range: ClosedRange<T>,
        background: AnyShapeStyle = AnyShapeStyle(Color.gray.opacity(0.3)),
        foreground: AnyShapeStyle,
        cornerRadius: CGFloat = 100,
        height: CGFloat? = 8) {
            self.selection = selection
            self.range = range
            self.background = background
            self.foreground = foreground
            self.cornerRadius = cornerRadius
            self.height = height
        }
    
    /// Init with plain Colors
    public init(
        selection: T,
        range: ClosedRange<T>,
        backgroundColor: Color = Color.gray.opacity(0.3),
        foregroundColor: Color = .blue,
        cornerRadius: CGFloat = 100,
        height: CGFloat? = 8) {
            self.selection = selection
            self.range = range
            self.background = AnyShapeStyle(backgroundColor)
            self.foreground = AnyShapeStyle(foregroundColor)
            self.cornerRadius = cornerRadius
            self.height = height
        }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(background)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(foreground)
                    .frame(width: getCurrentProgress(geo: geo))
            }
        }
        .frame(height: height)
    }
    
    private func getCurrentProgress(geo: GeometryProxy) -> CGFloat {
        /*
         Progress = ((Selection - Min) / (Max - Min)) * width
         
         Ex.
         If selection = 15 and range = 10...20
         Progress = (15 - 10) / (20 - 10) * width
         Progress = 5 / 10 * width
         Progress = 50% * width
         
         Ex.
         If selection = 25 and range = 0...100
         Progress = (25 - 0) / (100 - 0) * width
         Progress = 25 / 100 * width
         Progress  25% * width
         */
        
        let minRange = max(range.lowerBound, 0)
        let maxRange = max(range.upperBound, 1)
        
        // Ensure progress is within range
        var safeSelection = min(selection, maxRange)
        safeSelection = max(safeSelection, minRange)

        let percent = (safeSelection - minRange) / (maxRange - minRange)
        return CGFloat(percent) * geo.size.width
    }
}

@available(iOS 15, *)
struct CustomProgressBar_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var selection: Double = 55
        @State private var range: ClosedRange<Double> = 0...100

        var body: some View {
            CustomProgressBar(selection: selection, range: range)
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
