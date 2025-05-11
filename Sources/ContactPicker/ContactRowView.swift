import SwiftUI
import Contacts

public struct ContactRowView: View {
    public let contact: CNContact
    public let onSelect: (CNContact) -> Void

    public init(contact: CNContact, onSelect: @escaping (CNContact) -> Void) {
        self.contact = contact
        self.onSelect = onSelect
    }

    public var body: some View {
        Button(action: {
            onSelect(contact)
        }) {
            VStack(alignment: .leading) {
                Text("\(contact.givenName) \(contact.familyName)")
                    .font(.headline)

                if let email = contact.emailAddresses.first?.value as String? {
                    Text(email).font(.subheadline)
                }

                if let phone = contact.phoneNumbers.first?.value.stringValue {
                    Text(phone).font(.subheadline)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
