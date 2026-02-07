# SwiftfulUI

Reusable SwiftUI components library. Buttons, gestures, grids, scroll views, view modifiers, property wrappers, and more. iOS, macOS, tvOS.

## Buttons

- `.asButton()` wraps any view in a Button with a custom style
- `.asButton(.tap)` is the default — `onTapGesture`, no visual feedback
- `.asButton(.press)` — scale 0.975 on press
- `.asButton(.highlight)` — accent color overlay + scale 0.975 on press
- `.asButton(.opacity)` — opacity 0.85 on press
- `.asButton(scale:opacity:brightness:)` — fully custom button style
- `.asWebLink { URL(...) }` — wraps in a Link instead of a Button

```swift
Text("Save")
    .callToActionButton()
    .asButton(.press) {
        save()
    }
```

## View Extensions

```swift
.any()                    // -> AnyView
.tappableBackground()     // invisible tap target (Color.black.opacity(0.001))
.removeListRowFormatting() // removes List row insets and background
.callToActionButton()     // full-width styled CTA (font, color, padding, cornerRadius)
.ifSatisfiesCondition(bool) { $0.opacity(0.5) }  // conditional modifier
.ifSatisfiesCondition(bool) { $0.hidden() } else: { $0.overlay(Badge()) }  // with else
```

## View Modifiers

```swift
.onFirstAppear { }                    // runs once on first onAppear
.onFirstTask { await fetchData() }    // runs once on first .task (iOS 15+)
.onFirstDisappear { }                 // runs once on first onDisappear
.onNotificationReceived(name:) { }    // NotificationCenter listener
.asStretchyHeader(startingHeight:)    // stretchy header in ScrollView
```

## Property Wrappers

```swift
@UserDefault(key: "has_seen_onboarding", startingValue: false)
var hasSeenOnboarding: Bool

@UserDefaultEnum(key: "theme", startingValue: .system)
var theme: ThemeOption
```

- `UserDefault` supports: `Bool`, `Int`, `Float`, `Double`, `String`, `URL`
- `UserDefaultEnum` supports any `RawRepresentable` where `RawValue == String`

## Views

- `AsyncCallToActionButton(isLoading:title:action:)` — CTA with loading spinner
- `RootView(delegate:content:)` — app lifecycle event listener (foreground, background, etc.)
- `CountdownViewBuilder(endDate:content:)` — countdown timer
- `FlipView(isFlipped:front:back:)` — 3D flip animation

## Grids

- `NonLazyVGrid(columns:items:content:)` — non-lazy vertical grid
- `NonLazyHGrid(rows:items:content:)` — non-lazy horizontal grid

## Progress Bars

```swift
CustomProgressBar(selection: progress, range: 0...100)
CustomProgressBar(selection: progress, range: 0...100, foregroundColor: .blue, height: 8)
```

- iOS 15+ only
- Accepts any `BinaryFloatingPoint` for selection and range
- Supports `AnyShapeStyle` for gradient foregrounds

## LazyZStack

```swift
LazyZStack(allowSimultaneous: true, selection: selectedItem, items: items) { item in
    ItemView(item: item)
        .transition(.slide)
}
```

- Renders views lazily based on selection — only selected view (+ transitions) exist
- `allowSimultaneous: true` — both old and new views render during transitions
- `allowSimultaneous: false` — only selected view renders
- Supports `Identifiable`, `Int` range, and `Bool` selection

## Usage Guide

### Button style selection

IMPORTANT: ALWAYS prefer `.asButton()` over `Button()` or `.onTapGesture`. Every tappable element in the app should use `.asButton()` for consistent styling and behavior. Default to `.press` for most interactive elements.

- **CTAs, primary actions:** `.asButton(.press)` — standard press feedback
- **List rows, settings items:** `.asButton(.highlight)` — accent overlay for row-style taps
- **Subtle/plain taps:** `.asButton()` or `.asButton(.tap)` — no visual feedback
- **Destructive or secondary actions:** `.asButton(.opacity)` — dimming effect

### When to use callToActionButton()

- Use `.callToActionButton()` for full-width primary action buttons (Get Started, Save, Subscribe)
- Pair with `.asButton(.press)` for the press animation
- Do NOT use for list rows, navigation items, or icon buttons

### When to use ifSatisfiesCondition()

- ONLY use `.ifSatisfiesCondition()` for values that do NOT change while the view is on screen (e.g. `isDev`, `isiPad`, feature flags)
- NEVER use it for dynamic state that may toggle or animate — use native `if/else` or ternary operators instead
- The modifier captures `Self` before the condition is evaluated, which breaks SwiftUI's diffing and animation system for changing values
- ALWAYS prefer ternary operators when the condition controls a single parameter value (e.g. `.padding(isDev ? 20 : 8)`) — only use `ifSatisfiesCondition` when you need entirely different modifier chains that can't be expressed inline

### When to use tappableBackground()

- ALWAYS add `.tappableBackground()` before `.asButton()` if the view has transparent areas
- Without it, taps on transparent gaps will not register
- Not needed if the view already has an opaque background

### When to use LazyZStack vs TabView

- `LazyZStack` is low priority — only suggest it if explicitly asked or if the user is stacking multiple views and struggling to get transitions/animations working (very rare)
- ALWAYS prefer native SwiftUI patterns (`if/else`, `switch`, `TabView`) for view switching
- `LazyZStack` does NOT support swipe gestures — it's selection-driven only

### When to use onFirstAppear vs onFirstTask

- Use `.onFirstAppear` for synchronous setup (analytics, state init)
- Use `.onFirstTask` for async work (network calls, data loading)
- NEVER use `.onAppear` or `.task` for one-time setup — they re-fire on navigation returns

### When to use NonLazyVGrid vs LazyVGrid

- ALWAYS prefer native SwiftUI `LazyVGrid`/`LazyHGrid` by default
- Use `NonLazyVGrid`/`NonLazyHGrid` only when there are < 9 lightweight items that can load synchronously (no heavy async tasks)
- Do NOT use `NonLazyVGrid` for lists with images, network-loaded content, or unbounded data

### ScrollView components

- ALWAYS prefer native SwiftUI scroll APIs (`.scrollPosition`, `.scrollTargetLayout`, `.scrollIndicators`, etc.)
- The package's `ScrollViewWithOnScrollChanged` is a legacy fallback for apps targeting older OS versions
- For new projects targeting iOS 17+, never use the package scroll views

### Low-priority components

The following components exist in the package but should rarely be used unless explicitly requested:

- **AsyncViewBuilders** (`AsyncButton`, `AsyncViewBuilder`, `AsyncLetViewBuilder`) — native SwiftUI `.task` and `@State` patterns are preferred
- **AsyncCallToActionButton** — only use when you need the exact loading spinner + CTA pattern it provides
- **TabBars** (`TabBarViewBuilder`, `TabBarDefaultView`) — ALWAYS prefer native SwiftUI `TabView` with `.tabItem`. The package tab bar is a legacy component for heavily custom designs only
- **LazyZStack** — only use when explicitly asked or when native `if/else`/`switch` transitions are failing. Prefer native SwiftUI view switching patterns
