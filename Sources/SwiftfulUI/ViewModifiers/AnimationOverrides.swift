//
//  AnimationOverrides.swift
//  
//
//  Created by Nick Sarno on 10/7/22.
//

import Foundation
import SwiftUI

/// Similar to "withAnimation" except disables animation instead.
func withoutAnimation<Result>(_ body: () throws -> Result) rethrows -> Result {
    var transaction = Transaction()
    transaction.disablesAnimations = true
    return try withTransaction(transaction, body)
}

/// Similar to "withAnimation" but will override any concurrent animations.
func withHighPriorityAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    var transaction = Transaction(animation: animation)
    transaction.disablesAnimations = true
    return try withTransaction(transaction, body)
}
