//
//  RootView.swift
//
//
//  Created by Nick Sarno on 11/11/23.
//

import SwiftUI

public struct RootDelegate {
    /// The first "onAppear" of the application. Similar to "didFinishLaunching".
    var onApplicationDidAppear: (() -> Void)? = nil
    var onApplicationWillEnterForeground: ((Notification) -> Void)? = nil
    var onApplicationDidBecomeActive: ((Notification) -> Void)? = nil
    var onApplicationWillResignActive: ((Notification) -> Void)? = nil
    var onApplicationDidEnterBackground: ((Notification) -> Void)? = nil
    var onApplicationWillTerminate: ((Notification) -> Void)? = nil

    public init(
        onApplicationDidAppear: (() -> Void)? = nil,
        onApplicationWillEnterForeground: ((Notification) -> Void)? = nil,
        onApplicationDidBecomeActive: ((Notification) -> Void)? = nil,
        onApplicationWillResignActive: ((Notification) -> Void)? = nil,
        onApplicationDidEnterBackground: ((Notification) -> Void)? = nil,
        onApplicationWillTerminate: ((Notification) -> Void)? = nil
    ) {
        self.onApplicationDidAppear = onApplicationDidAppear
        self.onApplicationWillEnterForeground = onApplicationWillEnterForeground
        self.onApplicationDidBecomeActive = onApplicationDidBecomeActive
        self.onApplicationWillResignActive = onApplicationWillResignActive
        self.onApplicationDidEnterBackground = onApplicationDidEnterBackground
        self.onApplicationWillTerminate = onApplicationWillTerminate
    }
}

/// Make this the Root view of your application to recieve UIApplicationDelegates in your SwiftUI View code.
public struct RootView: View {
    
    let delegate: RootDelegate?
    let content: () -> any View
    
    public init(delegate: RootDelegate? = nil, content: @escaping () -> any View) {
        self.delegate = delegate
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            AnyView(content())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onFirstAppear {
            delegate?.onApplicationDidAppear?()
        }
        .onNotificationRecieved(
            name: UIApplication.willEnterForegroundNotification,
            action: { notification in
                delegate?.onApplicationWillEnterForeground?(notification)
            }
        )
        .onNotificationRecieved(
            name: UIApplication.didBecomeActiveNotification,
            action: { notification in
                delegate?.onApplicationDidBecomeActive?(notification)
            }
        )
        .onNotificationRecieved(
            name: UIApplication.willResignActiveNotification,
            action: { notification in
                delegate?.onApplicationWillResignActive?(notification)
            }
        )
        .onNotificationRecieved(
            name: UIApplication.didEnterBackgroundNotification,
            action: { notification in
                delegate?.onApplicationDidEnterBackground?(notification)
            }
        )
        .onNotificationRecieved(
            name: UIApplication.willTerminateNotification,
            action: { notification in
                delegate?.onApplicationWillTerminate?(notification)
            }
        )
    }
    
}

#Preview("RootView") {
    RootView(
        delegate: nil,
        content: {
            Text("Home")
        }
    )
}

