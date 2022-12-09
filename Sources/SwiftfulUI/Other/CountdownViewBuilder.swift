//
//  SwiftUIView.swift
//  
//
//  Created by Nick Sarno on 12/9/22.
//

import SwiftUI

struct CountdownViewBuilder<Content:View>: View {
    
    let content: (String) -> Content
    let onTimerEnded: (@MainActor () -> Void)?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var timeRemaining: Double
    
    init(endTime: Date, @ViewBuilder content: @escaping (String) -> Content, onTimerEnded: (@MainActor () -> Void)? = nil) {
        self.content = content
        self.onTimerEnded = onTimerEnded
        self._timeRemaining = State(wrappedValue: endTime.timeIntervalSince(Date()))
    }
    
    var body: some View {
        content(timeString(time: timeRemaining))
            .onReceive(timer) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer.upstream.connect().cancel()
                    self.onTimerEnded?()
                }
            }
    }
    
    //Convert the time into 24hr (24:00:00) format
    func timeString(time: Double) -> String {
        let hours   = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

struct CountdownViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        CountdownViewBuilder(endTime: Date().addingTimeInterval(60 * 60 * 2)) { timeString in
            Text(timeString)
        }
    }
}
