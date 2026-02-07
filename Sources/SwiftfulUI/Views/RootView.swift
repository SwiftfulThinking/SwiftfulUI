//
//  RootView.swift
//
//
//  Created by Nick Sarno on 11/11/23.
//

import SwiftUI

/// App delegate life cycle actions for SwiftUI.
///
/// ### onApplicationDidAppear:
///  When the app first appears. This is called when the SwiftUI View appears, which is after didFinishLaunchingWithOptions. There is no didFinishLaunchingWithOptions because that is triggered before SwiftUI renders.
///
///
/// ### onApplicationWillEnterForeground:
///   When the app transitions to active state. When the app will reactivate, this gets called immediately before applicationDidBecomeActive.
///
///
/// ### onApplicationDidBecomeActive:
///  When the app returns to active state after being in an inactive state.
///
///
/// ### onApplicationWillResignActive:
/// When the app transitions away from active state. Each time a temporary event, such as a phone call, happens this method gets called.
///   
///
/// ### onApplicationDidEnterBackground:
///  When the app enters the background but is still running. If the user is terminating the app, this is called immediately before applicationWillTerminate. The app will have approximately five seconds to perform tasks before the application terminates.
///
///
/// ### onApplicationWillTerminate:
///  When the app terminates. Events such as force quitting the iOS app or shutting down the device.
public struct RootDelegate {
    
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

/// Make this the Root view of your application to receive UIApplicationDelegate methods in your SwiftUI View.
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
        .onNotificationReceived(
            name: UIApplication.willEnterForegroundNotification,
            action: { notification in
                delegate?.onApplicationWillEnterForeground?(notification)
            }
        )
        .onNotificationReceived(
            name: UIApplication.didBecomeActiveNotification,
            action: { notification in
                delegate?.onApplicationDidBecomeActive?(notification)
            }
        )
        .onNotificationReceived(
            name: UIApplication.willResignActiveNotification,
            action: { notification in
                delegate?.onApplicationWillResignActive?(notification)
            }
        )
        .onNotificationReceived(
            name: UIApplication.didEnterBackgroundNotification,
            action: { notification in
                delegate?.onApplicationDidEnterBackground?(notification)
            }
        )
        .onNotificationReceived(
            name: UIApplication.willTerminateNotification,
            action: { notification in
                delegate?.onApplicationWillTerminate?(notification)
            }
        )
    }
    
}

#Preview("RootView") {
    ZStack {
        RootView(
            delegate: RootDelegate(
                onApplicationDidAppear: {
                    
                },
                onApplicationWillEnterForeground: { notification in
                    
                },
                onApplicationDidBecomeActive: { notification in
                    
                },
                onApplicationWillResignActive: { notification in
                    
                },
                onApplicationDidEnterBackground: { notification in
                    
                },
                onApplicationWillTerminate: { notification in
                    
                }
            ),
            content: {
                Text("Home")
            }
        )
        
        let delegate = RootDelegate(
            onApplicationDidAppear: nil,
            onApplicationWillEnterForeground: nil,
            onApplicationDidBecomeActive: nil,
            onApplicationWillResignActive: nil,
            onApplicationDidEnterBackground: nil,
            onApplicationWillTerminate: nil)
        
        RootView(
            delegate: delegate,
            content: {
                Text("Home")
            }
        )
    }
}

