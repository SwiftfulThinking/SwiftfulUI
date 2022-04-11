//
//  LocationReader.swift
//  
//
//  Created by Nick Sarno on 4/10/22.
//

import SwiftUI

@available(iOS 14, *)
/// Adds a transparent View and read it's center point.
///
/// Adds a GeometryReader with 0px by 0px frame.
public struct LocationReader: View {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (_ location: CGPoint) -> Void

    public var body: some View {
        FrameReader(coordinateSpace: coordinateSpace) { frame in
            onChange(CGPoint(x: frame.midX, y: frame.midY))
        }
        .frame(width: 0, height: 0, alignment: .center)
    }
}

@available(iOS 14, *)
public extension View {
    
    /// Get the center point of the View
    ///
    /// Adds a 0px GeometryReader to the background of a View.
    func readingLocation(coordinateSpace: CoordinateSpace = .global, onChange: @escaping (_ location: CGPoint) -> ()) -> some View {
        background(LocationReader(coordinateSpace: coordinateSpace, onChange: onChange))
    }
    
}

@available(iOS 14, *)
struct LocationReader_Previews: PreviewProvider {
    
    struct PreviewView: View {
        
        @State private var yOffset: CGFloat = 0
        
        var body: some View {
            ScrollView(.vertical) {
                VStack {
                    Text("")
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .background(Color.green)
                        .padding()
                        .readingLocation { location in
                            yOffset = location.y
                        }
                    
                    ForEach(0..<30) { x in
                        Text("")
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .background(Color.green)
                            .padding()
                    }
                }
            }
            .coordinateSpace(name: "test")
            .overlay(Text("Offset: \(yOffset)"))
        }
    }

    static var previews: some View {
        PreviewView()
    }
}
