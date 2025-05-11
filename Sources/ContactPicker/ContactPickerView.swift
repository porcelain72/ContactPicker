import SwiftUI
import Contacts

public struct ContactPickerView: View {
    @ObservedObject var model: ContactModel
    @State private var searchText: String = ""

    public init(model: ContactModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading) {
            TextField("Search contacts", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    model.filterContacts(searchText: newValue)
                }

            List(model.filteredContacts) { wrapper in
                ContactRowView(contact: wrapper.contact) { selected in
                    model.select(selected)
                }
            }

            if let selected = model.selectedContact {
                Divider()
                Text("Selected Contact:")
                    .font(.title3)
                    .padding(.top)
                Text("\(selected.givenName) \(selected.familyName)")
                if let email = selected.emailAddresses.first?.value as String? {
                    Text("Email: \(email)")
                }
                if let phone = selected.phoneNumbers.first?.value.stringValue {
                    Text("Phone: \(phone)")
                }
            }
        }
        .padding()
    }
}
