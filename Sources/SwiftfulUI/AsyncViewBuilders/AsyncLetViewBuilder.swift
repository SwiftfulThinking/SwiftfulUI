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
public struct AsyncLetViewBuilder<A, B>: View {
    
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
    var priority: TaskPriority = .userInitiated
    var redactedStyle: RedactedStyle = .never
    var redactedOnFailure: Bool = false
    let fetchA: () async throws -> A
    let fetchB: () async throws -> B
    let content: (AsyncLetLoadingPhase) -> any View
        
    public var body: some View {
        if #available(iOS 15.0, *) {
            AnyView(content(phase))
                .redacted(if: shouldBeRedacted, style: redactedStyle)
                .task(priority: priority) {
                    await performFetchRequestIfNeeded()
                }
        } else {
            AnyView(content(phase))
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

#Preview {
    if #available(iOS 14, *) {
        return AsyncLetViewBuilder(
            priority: .high,
            redactedStyle: .never,
            redactedOnFailure: true,
            fetchA: {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                return "Alpha"
            },
            fetchB: {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                return "Beta"
            },
            content: { phase in
                ZStack {
                    switch phase {
                    case .loading:
                        Text("Loading")
                    case .success(let a, let b):
                        HStack {
                            Text(a)
                            Text(b)
                        }
                    case .failure:
                        Text("FAILURE")
                    }
                }
            }
        )
    } else {
        return Text("err")
    }
}
