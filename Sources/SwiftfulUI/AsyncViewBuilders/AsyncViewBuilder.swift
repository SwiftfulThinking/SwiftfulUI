//
//  AsyncViewBuilder.swift
//  
//
//  Created by Nick Sarno on 3/30/22.
//

import SwiftUI

/// Load any View from an asynchronous method.
///
/// The fetch request is called every time the view appears, unless data has already been successfully loaded. The Task is cancelled when the view disappears.
@available(iOS 14, *)
public struct AsyncViewBuilder<T>: View {
    
    public enum AsyncLoadingPhase {
        /// No value is loaded.
        case loading
        /// A value successfully loaded.
        case success(value: T)
        /// A value failed to load with an error.
        case failure(error: Error?)
    }
    
    @State private var task: Task<Void, Never>? = nil
    @State private var phase: AsyncLoadingPhase = .loading
    var priority: TaskPriority = .userInitiated
    var redactedStyle: RedactedStyle = .never
    var redactedOnFailure: Bool = false
    let fetch: () async throws -> T
    let content: (AsyncLoadingPhase) -> any View
    
    public init(priority: TaskPriority = .userInitiated, redactedStyle: RedactedStyle = .never, redactedOnFailure: Bool = false, fetch: @escaping () async throws -> T, content: @escaping (AsyncLoadingPhase) -> any View) {
        self.priority = priority
        self.redactedStyle = redactedStyle
        self.redactedOnFailure = redactedOnFailure
        self.fetch = fetch
        self.content = content
    }
        
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
            phase = .success(value: try await fetch())
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
        return AsyncViewBuilder(
            priority: .high,
            redactedStyle: .never,
            redactedOnFailure: true,
            fetch: {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                return "heart.fill"
            }, content: { phase in
                ZStack {
                    switch phase {
                    case .loading:
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    case .success(let imageName):
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
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
