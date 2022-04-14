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
public struct AsyncViewBuilder<Content: View, T>: View {
    
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
    let priority: TaskPriority
    let redactedStyle: RedactedStyle
    let redactedOnFailure: Bool
    let fetch: () async throws -> T
    let content: (AsyncLoadingPhase) -> Content
    
    public init(
        priority: TaskPriority = .userInitiated,
        redactedStyle: RedactedStyle = .never,
        redactedOnFailure: Bool = false,
        fetch: @escaping () async throws -> T,
        @ViewBuilder content: @escaping (AsyncLoadingPhase) -> Content) {
            self.priority = priority
            self.redactedStyle = redactedStyle
            self.redactedOnFailure = redactedOnFailure
            self.fetch = fetch
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

// Note: Preview doesn't work... Xcode bug? Works when not in Package.
//@available(iOS 15, *)
//struct AsyncViewBuilder_Previews: PreviewProvider {
//    
//    struct PreviewView: View {
//        var body: some View {
//            ZStack {
//                AsyncViewBuilder {
//                    try await fetchImage()
//                } content: { phase in
//                    switch phase {
//                    case .loading:
//                        Image(uiImage: UIImage(systemName: "house.fill")!)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 200, height: 200)
//                    case .success(let image):
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 200, height: 200)
//                    case .failure:
//                        Text("FAILURE")
//                    }
//                }
//            }
//        }
//        
//        func fetchImage() async throws -> UIImage {
//            try? await Task.sleep(nanoseconds: 2_000_000_000)
//            return UIImage(systemName: "heart.fill")!
//        }
//    }
//
//    
//    static var previews: some View {
//        PreviewView()
//    }
//    
//}

