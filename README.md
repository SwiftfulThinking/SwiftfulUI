# SwiftfulUI 🎨

A library of reusable SwiftUI components that are missing from the SwiftUI framework. Includes buttons, gestures, grids, scroll views, view modifiers, property wrappers, and more.

## Features

- **Button styles** with press, highlight, opacity, and tap types
- **Gesture modifiers** for drag, magnification, and rotation
- **Non-lazy grids** for horizontal and vertical layouts
- **Scroll view enhancements** with scroll tracking and scroll-to support
- **View modifiers** for first-appear, notification listening, stretchy headers, and more
- **Property wrappers** for UserDefaults with type safety
- **Async view builders** for loading/error states
- **Reusable views** like AsyncCallToActionButton, CountdownViewBuilder, FlipView, and RootView

## Setup

<details>
<summary> Details (Click to expand) </summary>
<br>

Add SwiftfulUI to your project.

```
https://github.com/SwiftfulThinking/SwiftfulUI.git
```

Import the package.

```swift
import SwiftfulUI
```

</details>

## Buttons

<details>
<summary> Details (Click to expand) </summary>
<br>

Wrap any view in a button with a custom style.

```swift
// Tap (default) — no visual effect
Text("Tap me")
    .asButton {
        // action
    }

// Press — scale effect (0.975)
Text("Press me")
    .asButton(.press) {
        // action
    }

// Highlight — accent color overlay with scale
Text("Highlight me")
    .asButton(.highlight) {
        // action
    }

// Opacity — opacity effect (0.85)
Text("Opacity")
    .asButton(.opacity) {
        // action
    }

// Custom — configure scale, opacity, brightness
Text("Custom")
    .asButton(scale: 0.9, opacity: 0.8, brightness: 0.1) {
        // action
    }
```

Wrap a view in a Link with a custom style.

```swift
Text("Visit Google")
    .asWebLink {
        URL(string: "https://www.google.com")
    }
```

</details>

## View Extensions

<details>
<summary> Details (Click to expand) </summary>
<br>

```swift
// Wrap in AnyView
myView.any()

// Invisible tappable background
myView.tappableBackground()

// Remove default List row formatting
myView.removeListRowFormatting()

// Conditional view modifier
myView.ifSatisfiesCondition(someCondition) { view in
    view.opacity(0.5)
}

// Call-to-action button styling
Text("Get Started")
    .callToActionButton()

// With custom parameters
Text("Subscribe")
    .callToActionButton(
        font: .headline,
        foregroundColor: .white,
        backgroundColor: .accentColor,
        verticalPadding: 12,
        horizontalPadding: nil,
        cornerRadius: 16
    )
```

</details>

## View Modifiers

<details>
<summary> Details (Click to expand) </summary>
<br>

```swift
// Execute action only on first appear (sync)
myView.onFirstAppear {
    loadData()
}

// Execute async action only on first appear (iOS 15+)
myView.onFirstTask {
    await fetchData()
}

// Execute action only on first disappear
myView.onFirstDisappear {
    cleanup()
}

// Listen for NotificationCenter notifications
myView.onNotificationReceived(name: .myNotification) { notification in
    handleNotification(notification)
}

// Stretchy header effect
ScrollView {
    myHeaderView
        .asStretchyHeader(startingHeight: 300)
}
```

</details>

## Gestures

<details>
<summary> Details (Click to expand) </summary>
<br>

```swift
// Drag gesture with callbacks
myView.addDragGesture(
    onChanged: { value in },
    onEnded: { value in }
)

// Magnification gesture
myView.addMagnificationGesture(
    onChanged: { value in },
    onEnded: { value in }
)

// Rotation gesture
myView.addRotationGesture(
    onChanged: { value in },
    onEnded: { value in }
)
```

</details>

## Grids

<details>
<summary> Details (Click to expand) </summary>
<br>

Non-lazy grids that render all items immediately.

```swift
// Vertical grid
NonLazyVGrid(columns: 3, items: myItems) { item in
    ItemView(item: item)
}

// Horizontal grid
NonLazyHGrid(rows: 2, items: myItems) { item in
    ItemView(item: item)
}
```

</details>

## Scroll Views

<details>
<summary> Details (Click to expand) </summary>
<br>

```swift
// Track scroll position changes
ScrollViewWithOnScrollChanged(
    onScrollChanged: { offset in
        // React to scroll offset
    },
    content: {
        // Your content
    }
)
```

</details>

## Property Wrappers

<details>
<summary> Details (Click to expand) </summary>
<br>

Type-safe UserDefaults property wrappers.

```swift
// For standard types (Bool, Int, Float, Double, String, URL)
@UserDefault(key: "has_seen_onboarding", startingValue: false)
var hasSeenOnboarding: Bool

// For String-backed enums
@UserDefaultEnum(key: "theme", startingValue: .system)
var theme: ThemeOption
```

</details>

## Async View Builders

<details>
<summary> Details (Click to expand) </summary>
<br>

Handle async loading states declaratively.

```swift
AsyncCallToActionButton(
    isLoading: isLoading,
    title: "Save",
    action: {
        // action
    }
)
```

</details>

## Views

<details>
<summary> Details (Click to expand) </summary>
<br>

```swift
// RootView — handles app lifecycle events
RootView(
    delegate: RootDelegate(
        onApplicationDidAppear: { },
        onApplicationWillEnterForeground: { _ in },
        onApplicationDidBecomeActive: { },
        onApplicationWillResignActive: { },
        onApplicationDidEnterBackground: { },
        onApplicationWillTerminate: { }
    ),
    content: {
        // Your app content
    }
)

// CountdownViewBuilder — countdown timer display
CountdownViewBuilder(endDate: futureDate) { timeRemaining in
    Text(timeRemaining)
}

// FlipView — 3D flip between front and back
FlipView(isFlipped: $isFlipped, front: {
    FrontView()
}, back: {
    BackView()
})
```

</details>

## Progress Bars

<details>
<summary> Details (Click to expand) </summary>
<br>

Customizable progress bar with support for any numeric range (iOS 15+).

```swift
// Basic usage (0 to 100)
CustomProgressBar(
    selection: 55,
    range: 0...100
)

// With custom colors
CustomProgressBar(
    selection: progress,
    range: 0...100,
    backgroundColor: Color.gray.opacity(0.3),
    foregroundColor: .blue,
    cornerRadius: 100,
    height: 8
)

// With gradient foreground
CustomProgressBar(
    selection: progress,
    range: 0...100,
    foreground: AnyShapeStyle(
        LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
    )
)
```

</details>

## LazyZStack

<details>
<summary> Details (Click to expand) </summary>
<br>

A ZStack that lazily renders views based on a selection, with built-in support for SwiftUI transitions. Only the selected view is rendered (or optionally allows simultaneous rendering for transition animations).

```swift
// With Identifiable items
LazyZStack(
    allowSimultaneous: true,
    selection: selectedItem,
    items: items
) { item in
    ItemView(item: item)
        .transition(.slide)
}

// With Int selection
LazyZStack(
    allowSimultaneous: true,
    selection: selectedIndex,
    items: 0..<4
) { index in
    PageView(index: index)
        .transition(.slide)
}

// With Bool selection
LazyZStack(
    allowSimultaneous: false,
    selection: isShowingDetail
) { (value: Bool) in
    if value {
        DetailView()
    } else {
        ListView()
    }
}
```

- `allowSimultaneous: true` — both old and new views render during transitions
- `allowSimultaneous: false` — only the selected view renders at a time

</details>

## Other Components

<details>
<summary> Details (Click to expand) </summary>
<br>

- **Backgrounds & Borders** — Fill, border, and gradient background modifiers
- **Fonts** — Custom font modifiers with animation support
- **GeometryReaders** — Frame and location readers
- **Redacted** — Redacted/skeleton loading modifier
- **TabBars** — Customizable tab bar with TabBarItem support
- **Toggles** — Custom toggle view

See the SwiftUI Previews within source files for example implementations.

</details>

## Platform Support

- **iOS 13.0+**
- **macOS 10.14+**
- **tvOS 13.0+**

## License

SwiftfulUI is available under the MIT license.
