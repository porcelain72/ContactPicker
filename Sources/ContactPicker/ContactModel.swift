import Contacts
import Combine

public class ContactModel: ObservableObject {
    @Published public var contacts: [ContactWrapper] = []
    @Published public var filteredContacts: [ContactWrapper] = []
    @Published public var selectedContact: CNContact?

    private var allContacts: [ContactWrapper] = []

    public init() {
        fetchContacts()
    }

    public func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, _ in
            guard granted else { return }

            DispatchQueue.global(qos: .userInitiated).async {
                let keys: [CNKeyDescriptor] = [
                    CNContactPostalAddressesKey as CNKeyDescriptor,
                    CNContactGivenNameKey as CNKeyDescriptor,
                    CNContactFamilyNameKey as CNKeyDescriptor,
                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                    CNContactEmailAddressesKey as CNKeyDescriptor,
                    CNContactThumbnailImageDataKey as CNKeyDescriptor
                ]
                let request = CNContactFetchRequest(keysToFetch: keys)

                var fetched: [ContactWrapper] = []

                do {
                    try store.enumerateContacts(with: request) { contact, _ in
                        fetched.append(ContactWrapper(id: contact.identifier, contact: contact))
                    }

                    DispatchQueue.main.async {
                        self.allContacts = fetched
                        self.contacts = fetched
                        self.filteredContacts = fetched
                    }
                } catch {
                    print("Failed to fetch contacts: \(error)")
                }
            }
        }
    }

    public func filterContacts(searchText: String) {
        if searchText.isEmpty {
            filteredContacts = allContacts
        } else {
            filteredContacts = allContacts.filter {
                let name = "\($0.contact.givenName) \($0.contact.familyName)"
                return name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    public func select(_ contact: CNContact) {
        selectedContact = contact
    }
}
