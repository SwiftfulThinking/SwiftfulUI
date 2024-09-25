//
//  SwiftUIView.swift
//  
//
//  Created by Nick Sarno on 12/9/22.
//

import SwiftUI

@available(iOS 14, *)
public struct CountdownViewBuilder<Content:View>: View {
    
    let endTime: Date
    var displayOption: Double.HoursMinutesSecondsDisplayOption = .timeAs_00_00_00
    let content: (String) -> Content
    var onTimerEnded: (@MainActor () -> Void)? = nil
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var timeRemaining: Double = 0
    
    public init(endTime: Date, displayOption: Double.HoursMinutesSecondsDisplayOption, content: @escaping (String) -> Content, onTimerEnded: ( () -> Void)? = nil) {
        self.endTime = endTime
        self.displayOption = displayOption
        self.content = content
        self.onTimerEnded = onTimerEnded
    }
        
    public var body: some View {
        content(timeRemaining.asHoursMinutesSeconds(display: displayOption))
            .onReceive(timer) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer.upstream.connect().cancel()
                    self.onTimerEnded?()
                }
            }
            .onChange(of: endTime, perform: { newValue in
                timeRemaining = newValue.timeIntervalSince(Date())
            })
            .onAppear {
                timeRemaining = endTime.timeIntervalSince(Date())
            }
            .onNotificationRecieved(name: UIApplication.didBecomeActiveNotification, action: { _ in
                timeRemaining = endTime.timeIntervalSince(Date())
            })
    }
}

@available(iOS 14, *)
struct CountdownViewBuilder_Previews: PreviewProvider {
    
    static let endTime = Date().addingTimeInterval(60 * 60 * 2)
    static let endTime2 = Date().addingTimeInterval(60 * 60 * 24 * 7)

    static var previews: some View {
        VStack(spacing: 20) {
            CountdownViewBuilder(
                endTime: endTime,
                displayOption: .timeAs_00_00_00,
                content: { string in
                    Text(string)
                },
                onTimerEnded: {
                    
                }
            )
            
            CountdownViewBuilder(
                endTime: endTime,
                displayOption: .timeAs_h_m_s,
                content: { string in
                    Text(string)
                },
                onTimerEnded: {
                    
                }
            )
            
            CountdownViewBuilder(
                endTime: endTime2,
                displayOption: .timeAs_d_h_m,
                content: { string in
                    Text(string)
                },
                onTimerEnded: {
                    
                }
            )
        }
    }
}

extension Double {
    
    public enum HoursMinutesSecondsDisplayOption {
        case timeAs_00_00_00, timeAs_h_m_s, timeAs_d_h_m
        
        public func stringValue(of value: Double) -> String {
            switch self {
            case .timeAs_00_00_00:
                return value.asHoursMinutesSeconds_as_00_00_00
            case .timeAs_h_m_s:
                return value.asHoursMinutesSeconds_as_h_m_s
            case .timeAs_d_h_m:
                return value.asDaysHoursMinutes
            }
        }
    }
    
    public func asHoursMinutesSeconds(display: HoursMinutesSecondsDisplayOption) -> String {
        display.stringValue(of: self)
    }

    public var asHoursMinutesSeconds_as_00_00_00: String {
        let hours   = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    public var asHoursMinutesSeconds_as_h_m_s: String {
        let timeInterval = TimeInterval(self)
        let date = Date(timeIntervalSinceNow: timeInterval)
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(), to: date)
        
        var timeString = ""
                
        if let hours = components.hour, hours > 0 {
            timeString += "\(hours)h "
        }
        
        if let minutes = components.minute, (minutes > 0 || (components.hour ?? 0) > 0) {
            timeString += "\(minutes)m "
        }
        
        if let seconds = components.second {
            timeString += "\(seconds)s"
        }
        
        return timeString.isEmpty ? "0s" : timeString
    }
    
    public var asDaysHoursMinutes: String {
        let days = Int(self) / 86400
        let hours = (Int(self) % 86400) / 3600
        let minutes = (Int(self) % 3600) / 60
        
        var timeString = ""
        
        if days > 0 {
            timeString += "\(days)d "
        }
        
        if hours > 0 || days > 0 {
            timeString += "\(hours)h "
        }
        
        if minutes > 0 || hours > 0 || days > 0 {
            timeString += "\(minutes)m"
        }
        
        return timeString.isEmpty ? "0m" : timeString
    }
}
