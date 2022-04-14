//
//  Haptics.swift
//  
//
//  Created by Nick Sarno on 4/8/22.
//

import Foundation
import UIKit

final class Haptics {

    static let shared = Haptics()
    private init() {}
    
    let notificationGenerator = UINotificationFeedbackGenerator()
    let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let selectionGenerator = UISelectionFeedbackGenerator()
    
    /// Prepare the appropriate haptic generator prior to haptic occurrence.
    ///
    /// Call prepare() before the event that triggers feedback. The system needs time to prepare the Taptic Engine for minimal latency.
    /// Calling prepare() and then immediately triggering feedback (without any time in between) does not improve latency.
    ///
    /// - Parameter option: If providing an option, only prepare that option. If nil, prepare all options.
    func prepare(option: HapticOption? = nil) {
        guard let option = option else {
            notificationGenerator.prepare()
            lightGenerator.prepare()
            mediumGenerator.prepare()
            heavyGenerator.prepare()
            return
        }
        
        switch option {
        case .success, .error, .warning: notificationGenerator.prepare()
        case .light: lightGenerator.prepare()
        case .medium: mediumGenerator.prepare()
        case .heavy: heavyGenerator.prepare()
        case .selection: selectionGenerator.prepare()
        case .never: break
        }
    }
    
    /// Immediately cause haptic occurrence.
    /// - Warning: It is recommended to call 'Haptics.prepare' prior to 'vibrate' to remove latency issues. However, vibrate will occur regardless.
    func vibrate(option: HapticOption) {
        switch option {
        case .success: notificationGenerator.notificationOccurred(.success)
        case .error: notificationGenerator.notificationOccurred(.error)
        case .warning: notificationGenerator.notificationOccurred(.warning)
        case .light: lightGenerator.impactOccurred()
        case .medium: mediumGenerator.impactOccurred()
        case .heavy: heavyGenerator.impactOccurred()
        case .selection: selectionGenerator.selectionChanged()
        case .never: break
        }
    }
    
}
