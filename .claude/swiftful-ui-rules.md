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

IMPORTANT: Default to `.press` for most interactive elements. Only use alternatives for specific UX reasons.

- **CTAs, primary actions:** `.asButton(.press)` — standard press feedback
- **List rows, settings items:** `.asButton(.highlight)` — accent overlay for row-style taps
- **Subtle/plain taps:** `.asButton()` or `.asButton(.tap)` — no visual feedback
- **Destructive or secondary actions:** `.asButton(.opacity)` — dimming effect

### When to use callToActionButton()

- Use `.callToActionButton()` for full-width primary action buttons (Get Started, Save, Subscribe)
- Pair with `.asButton(.press)` for the press animation
- Do NOT use for list rows, navigation items, or icon buttons

### When to use tappableBackground()

- ALWAYS add `.tappableBackground()` before `.asButton()` if the view has transparent areas
- Without it, taps on transparent gaps will not register
- Not needed if the view already has an opaque background

### When to use LazyZStack vs TabView

- Use `LazyZStack` when you need custom transitions between views controlled by selection
- Use `TabView` with `.tabViewStyle(.page)` for swipeable pages
- `LazyZStack` does NOT support swipe gestures — it's selection-driven only

### When to use onFirstAppear vs onFirstTask

- Use `.onFirstAppear` for synchronous setup (analytics, state init)
- Use `.onFirstTask` for async work (network calls, data loading)
- NEVER use `.onAppear` or `.task` for one-time setup — they re-fire on navigation returns

### When to use NonLazyVGrid vs LazyVGrid

- Use `NonLazyVGrid` when all items must render immediately (small lists, layout-dependent content)
- Use `LazyVGrid` (SwiftUI built-in) for large or infinite lists
- `NonLazyVGrid` is best for < 50 items where lazy loading adds unnecessary complexity
