import SwiftUI
import ContactPicker

@main
struct ContactPickerExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContactPickerView(model: ContactModel())
                .frame(width: 400, height: 600)
        }
    }
}
