//
//  AsyncLetViewBuilder.swift
//  
//
//  Created by Nick Sarno on 3/30/22.
//

import Foundation
import SwiftUI

/// Load any View from two asynchronous methods concurrently.
///
/// The fetch requests are called every time the view appears, unless data has already been successfully loaded. The Tasks are cancelled when the view disappears.
@available(iOS 14, *)
public struct AsyncLetViewBuilder<Content: View, A, B>: View {
    
    public enum AsyncLetLoadingPhase {
        /// No value is loaded.
        case loading
        /// A value successfully loaded.
        case success(valueA: A, valueB: B)
        /// A value failed to load with an error.
        case failure(error: Error?)
    }
    
    @State private var task: Task<Void, Never>? = nil
    @State private var phase: AsyncLetLoadingPhase = .loading
    let priority: TaskPriority
    let redactedStyle: RedactedStyle
    let redactedOnFailure: Bool
    let fetchA: () async throws -> A
    let fetchB: () async throws -> B
    let content: (AsyncLetLoadingPhase) -> Content
    
    public init(
        priority: TaskPriority = .userInitiated,
        redactedStyle: RedactedStyle = .never,
        redactedOnFailure: Bool = false,
        fetchA: @escaping () async throws -> A,
        fetchB: @escaping () async throws -> B,
        @ViewBuilder content: @escaping (AsyncLetLoadingPhase) -> Content) {
            self.priority = priority
            self.redactedStyle = redactedStyle
            self.redactedOnFailure = redactedOnFailure
            self.fetchA = fetchA
            self.fetchB = fetchB
            self.content = content
        }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            content(phase)
                .redacted(if: shouldBeRedacted, style: redactedStyle)
                .task(priority: priority) {
                    await performFetchRequestIfNeeded()
                }
        } else {
            content(phase)
                .redacted(if: shouldBeRedacted, style: redactedStyle)
                .onAppear {
                    task = Task(priority: priority) {
                        await performFetchRequestIfNeeded()
                    }
                }
                .onDisappear {
                    task?.cancel()
                }
        }
    }
    
    private func performFetchRequestIfNeeded() async {
        // This will be called every time the view appears.
        // If we already performed a successful fetch, there's no need to refetch.
        switch phase {
        case .loading, .failure:
            break
        case .success:
            return
        }
        
        do {
            async let fetchA = await fetchA()
            async let fetchB = await fetchB()
            phase = await .success(valueA: try fetchA, valueB: try fetchB)
        } catch {
            phase = .failure(error: error)
        }
    }
    
    private var shouldBeRedacted: Bool {
        switch phase {
        case .loading: return true
        case .success: return false
        case .failure: return redactedOnFailure
        }
    }
}
