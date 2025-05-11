import SwiftUI
import Contacts

public struct ContactPickerView: View {
    @ObservedObject var model: ContactModel
    @State private var searchText: String = ""

    public init(model: ContactModel) {
        self.model = model
    }

    public var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                TextField("Search contacts", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        model.filterContacts(searchText: newValue)
                    }

                ScrollViewReader { scrollProxy in
                    List {
                        ForEach(sectionIndexTitles, id: \.self) { letter in
                            if let sectionContacts = groupedContacts[letter] {
                                Section(header: Text(letter).font(.headline).id(letter)) {
                                    ForEach(sectionContacts) { wrapper in
                                        ContactRowView(contact: wrapper.contact) { selected in
                                            model.select(selected)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .overlay(
                        VStack {
                            Spacer()
                            ForEach(sectionIndexTitles, id: \.self) { letter in
                                Button(letter) {
                                    withAnimation {
                                        scrollProxy.scrollTo(letter, anchor: .top)
                                    }

                                }
                                .font(.caption)
                                .padding(.vertical, 1)
                                .buttonStyle(PlainButtonStyle())
                            }
                            Spacer()
                        }
                        .padding(.trailing, 4)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    )
                }

                if let selected = model.selectedContact {
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Selected Contact:")
                            .font(.title3)
                            .foregroundColor(.accentColor)
                        Text("\(selected.givenName) \(selected.familyName)")
                            .font(.headline)
                        if let email = selected.emailAddresses.first?.value as String? {
                            Text("Email: \(email)")
                                .foregroundColor(.secondary)
                        }
                        if let phone = selected.phoneNumbers.first?.value.stringValue {
                            Text("Phone: \(phone)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.windowBackgroundColor)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                }
            }
        }
        .padding()
        .background(Color(.textBackgroundColor))
    }

    private var groupedContacts: [String: [ContactWrapper]] {
        let collator = Locale.current.collator
        let sorted = model.filteredContacts.sorted {
            collator.compare($0.contact.familyName, $1.contact.familyName) == .orderedAscending
        }

        return Dictionary(grouping: sorted) { wrapper in
            let name = wrapper.contact.familyName
            return String(name.prefix(1)).uppercased()
        }
    }

    private var sectionIndexTitles: [String] {
        groupedContacts.keys.sorted()
    }
}

fileprivate extension Locale {
    var collator: Collator {
        return Collator(locale: self)
    }
}

fileprivate struct Collator {
    let locale: Locale

    func compare(_ lhs: String, _ rhs: String) -> ComparisonResult {
        return lhs.compare(rhs, locale: locale)
    }
}
