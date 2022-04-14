//
//  CustomProgressBar.swift
//  
//
//  Created by Nick Sarno on 4/13/22.
//

import SwiftUI

@available(iOS 15, *)
/// Customizable progress bar.
struct CustomProgressBar<T: BinaryFloatingPoint>: View {
        
    let selection: T
    let range: ClosedRange<T>
    let background: AnyShapeStyle
    let foreground: AnyShapeStyle
    let cornerRadius: CGFloat
    let height: CGFloat?
    
    /// Init with AnyShapeStyle (supports gradients)
    init(
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
    init(
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
    
    var body: some View {
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
            VStack {
                Text("Selection: \(selection)")
                Text("Range: \(range.lowerBound) : \(range.upperBound)")

                VStack {
                    CustomProgressBar(selection: selection, range: range, cornerRadius: 0)
                        .padding()
                    
                    CustomProgressBar(
                        selection: selection,
                        range: range,
                        background: AnyShapeStyle(Color.yellow),
                        foreground: AnyShapeStyle(LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .bottomTrailing)))
                    
                        .padding()
                    
                    CustomProgressBar(selection: selection, range: range, backgroundColor: .green, foregroundColor: .black, height: 20)
                        .padding()
                }
                .background(Color.black.opacity(0.001))
                .onTapGesture {
                    withAnimation {
                        selection = .random(in: 0...100)
                        let min: Double = .random(in: 0...50)
                        let max: Double = .random(in: 50...100)
                        range = min...max
                    }
                }
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
