//
//  FrameReader.swift
//  
//
//  Created by Nick Sarno on 4/7/22.
//

import SwiftUI

@available(iOS 14, *)
struct FrameReader: View {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (_ frame: CGRect) -> Void

    var body: some View {
        GeometryReader { geo in
            Text("")
                .frame(width: 0, height: 0)
                .onChange(of: geo.frame(in: coordinateSpace), perform: onChange)
        }
        .frame(width: 0, height: 0)
    }
}


@available(iOS 14, *)
struct SwiftUIView_Previews: PreviewProvider {
    
    struct PreviewView: View {
        
        @State private var yOffset: CGFloat = 0
        
        var body: some View {
            ScrollView(.vertical) {
                FrameReader(coordinateSpace: .named("test")) { frame in
                    yOffset = frame.minY
                }


                VStack {
                    ForEach(0..<30) { x in
                        Text("x: \(x)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .background(Color.green)
                            .padding()
                            .id(x)
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
