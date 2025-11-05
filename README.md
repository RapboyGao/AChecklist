# AChecklist

A powerful and flexible checklist management library for Swift.

## Languages / 语言
- [English](README.md) (当前页面)
- [中文](README_zh.md)
- [日本語](README_ja.md)
- [한국어](README_ko.md)

## Overview

AChecklist is a Swift package that provides a robust framework for creating and managing checklists with advanced features like mutual exclusion sections, expiration times, and detailed state management. It's designed to be used in iOS, macOS, tvOS, and watchOS applications.

## Features

- **Hierarchical Structure**: Organize checklists with sections and items
- **Mutual Exclusion**: Define sections that are mutually exclusive, allowing only one to be selected at a time
- **State Management**: Track and visualize completion status with color coding
- **Expiration Times**: Set items to expire after a configurable time period
- **Encrypted Storage**: Secure checklist data with encryption
- **Localization Support**: Built-in support for internationalization
- **Cross-Platform**: Works across all Apple platforms

## Installation

### Swift Package Manager

To integrate AChecklist into your project using Swift Package Manager, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/RapboyGao/AChecklist.git", branch: "main")
]
```

Then, add AChecklist as a dependency to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["AChecklist"]
    )
]
```

## Usage

### Creating a Simple Checklist

```swift
import AChecklist

// Create a checklist with sections and items
let checklist = AChecklist(
    name: "Daily Tasks",
    sections: [
        AChecklistSection(
            name: "Morning Routine",
            items: [
                AChecklistItem(title: "Wake up", detail: "7:00 AM"),
                AChecklistItem(title: "Exercise", detail: "30 minutes"),
                AChecklistItem(title: "Breakfast", detail: "Protein and fruits")
            ]
        ),
        AChecklistSection(
            name: "Evening Tasks",
            items: [
                AChecklistItem(title: "Dinner", detail: "Healthy meal"),
                AChecklistItem(title: "Read", detail: "30 pages")
            ]
        )
    ]
)
```

### Using Mutual Exclusion Sections

Mutual exclusion allows you to create sections where only one can be selected at a time:

```swift
// Create a checklist with mutually exclusive sections
var checklist = AChecklist(
    name: "Transportation Options",
    sections: [
        AChecklistSection(
            name: "Car",
            items: [
                AChecklistItem(title: "Start engine"),
                AChecklistItem(title: "Fasten seatbelt")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "Public Transit",
            items: [
                AChecklistItem(title: "Check schedule"),
                AChecklistItem(title: "Buy ticket")
            ]
        ).mutating { $0.isMutualExclusion = true },
        AChecklistSection(
            name: "Bicycle",
            items: [
                AChecklistItem(title: "Check tires"),
                AChecklistItem(title: "Put on helmet")
            ]
        ).mutating { $0.isMutualExclusion = true }
    ]
)
```

### Checking and Unchecking Items

```swift
// Check an item
checklist.sections[0].items[0].isChecked = true

// Toggle an item's state
checklist.sections[0].items[1].toggle()

// Check all items in a section
checklist.sections[1].status = .checked

// Get the overall checklist status
let status = checklist.status // .unchecked, .partiallyChecked, or .checked
```

### Expiration Times

```swift
// Create an item with a custom expiration time
var item = AChecklistItem(title: "Take medication")
item.expiresAfter = DateComponents(hour: 4)

// Check if an item has expired
let isExpired = item.isExpired(now: Date())
```

## Main Components

### AChecklist
The main container for organizing sections and items.

### AChecklistSection
A group of related checklist items, can be marked as mutually exclusive.

### AChecklistItem
An individual task with title, detail, completion state, and expiration settings.

### AChecklistStatus
Enum representing the completion status of a checklist or section:
- `.unchecked`: No items are checked
- `.partiallyChecked`: Some items are checked
- `.checked`: All items are checked

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

AChecklist is available under the MIT license. See the LICENSE file for more information.