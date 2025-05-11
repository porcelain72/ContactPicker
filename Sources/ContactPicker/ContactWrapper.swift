import Contacts

public struct ContactWrapper: Identifiable {
    public let id: String
    public let contact: CNContact
}
