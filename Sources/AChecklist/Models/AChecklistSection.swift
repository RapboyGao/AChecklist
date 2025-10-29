import Foundation

public struct AChecklistSection: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var name: String
    public var items: [AChecklistItem]

    public var status: AChecklistStatus {
        get {
            let checkedItems: [AChecklistItem] = items.filter { $0.isChecked }
            if checkedItems.count == items.count {
                return .checked
            } else if checkedItems.count > 0 {
                return .partiallyChecked
            } else {
                return .unchecked
            }
        }
        set {
            switch newValue {
            case .checked:
                for index in items.indices {
                    items[index].isChecked = true
                }
            case .partiallyChecked:
                () // do nothing
            case .unchecked:
                for index in items.indices {
                    items[index].isChecked = false
                }   
            }
        }
    }

    public init(name: String, items: [AChecklistItem]) {
        self.id = UUID()
        self.name = name
        self.items = items
    }
}
