//
//  AnyNotificationListenerViewModifier.swift
//
//
//  Created by Nick Sarno on 11/11/23.
//

import Foundation
import SwiftUI

struct AnyNotificationListenerViewModifier: ViewModifier {
    
    let notificationName: Notification.Name
    let onNotificationReceived: @MainActor (Notification) -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: notificationName), perform: { notification in
                onNotificationReceived(notification)
            })
    }
}

extension View {
    
    public func onNotificationReceived(name: Notification.Name, action: @MainActor @escaping (Notification) -> Void) -> some View {
        modifier(AnyNotificationListenerViewModifier(notificationName: name, onNotificationReceived: action))
    }
    
}
