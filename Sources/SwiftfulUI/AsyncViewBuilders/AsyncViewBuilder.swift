//
//  AsyncViewBuilder.swift
//  
//
//  Created by Nick Sarno on 3/30/22.
//

import SwiftUI

@available(iOS 14, *)
public struct AsyncViewBuilder<Content: View, T>: View {
    
    public enum AsyncLoadingPhase {
        /// No value is loaded.
        case loading
        /// A value successfully loaded.
        case success(value: T)
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
    @State private var phase: AsyncLoadingPhase = .loading
    let redactedStyle: RedactedStyle
    let priority: TaskPriority
    let fetch: () async throws -> T
    let content: (AsyncLoadingPhase) -> Content
    
    public init(
        redactedStyle: RedactedStyle = .none,
        priority: TaskPriority = .userInitiated,
        fetch: @escaping () async throws -> T,
        @ViewBuilder content: @escaping (AsyncLoadingPhase) -> Content) {
            self.redactedStyle = redactedStyle
            self.priority = priority
            self.fetch = fetch
            self.content = content
        }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            content(phase)
                .redacted(if: phase.shouldBeRedacted, style: redactedStyle)
                .task(priority: priority) {
                    await performFetchRequestIfNeeded()
                }
        } else {
            content(phase)
                .redacted(if: phase.shouldBeRedacted, style: redactedStyle)
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
