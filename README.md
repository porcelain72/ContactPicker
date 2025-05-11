# ContactPicker

A SwiftUI-based, macOS-compatible contact picker using the Contacts framework.

## Features
- Fetches macOS contacts
- Searchable contact list
- Selectable contact row
- MVVM architecture
- Swift Package compatible

## Installation

### Swift Package Manager

In Xcode:
- File > Add Packages
- Enter GitHub URL for this repo
- Import: `import ContactPicker`

## Example

```swift
import ContactPicker

struct ContentView: View {
    var body: some View {
        ContactPickerView(model: ContactModel())
            .frame(width: 400, height: 600)
    }
}
```

## License

MIT
