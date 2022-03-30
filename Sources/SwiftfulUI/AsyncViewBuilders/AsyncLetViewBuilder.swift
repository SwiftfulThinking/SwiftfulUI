//
//  AsyncLetViewBuilder.swift
//  
//
//  Created by Nick Sarno on 3/30/22.
//

import Foundation
import SwiftUI

@available(iOS 14, *)
struct AsyncLetViewBuilder<Content: View, A, B>: View {
    
    public enum AsyncLetLoadingPhase {
        /// No value is loaded.
        case loading
        /// A value successfully loaded.
        case success(valueA: A?, valueB: B?)
        /// A value failed to load with an error.
        case failure(error: Error?)
        
        var shouldBeRedacted: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }
    
    @State private var task: Task<Void, Never>? = nil
    @State private var phase: AsyncLetLoadingPhase = .loading
    let redactedStyle: RedactedStyle
    let fetchA: () async throws -> A?
    let fetchB: () async throws -> B?
    let content: (AsyncLetLoadingPhase) -> Content
    
    public init(
        redactedStyle: RedactedStyle = .none,
        fetchA: @escaping () async throws -> A?,
        fetchB: @escaping () async throws -> B?,
        @ViewBuilder content: @escaping (AsyncLetLoadingPhase) -> Content) {
            self.redactedStyle = redactedStyle
            self.fetchA = fetchA
            self.fetchB = fetchB
            self.content = content
        }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            content(phase)
                .redacted(if: phase.shouldBeRedacted, style: redactedStyle)
                .task {
                    await performFetchRequestIfNeeded()
                }
        } else {
            content(phase)
                .redacted(if: phase.shouldBeRedacted, style: redactedStyle)
                .onAppear {
                    task = Task {
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
        case .success(valueA: let a, valueB: let b):
            guard a == nil || b == nil else { return }
        }
        
        do {
            async let fetchA = await fetchA()
            async let fetchB = await fetchB()
            phase = await .success(valueA: try fetchA, valueB: try fetchB)
        } catch {
            phase = .failure(error: error)
        }
    }
}
