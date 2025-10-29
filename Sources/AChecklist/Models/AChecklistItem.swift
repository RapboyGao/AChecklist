import Foundation

public struct AChecklistItem: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var title: String
    public var detail: String
    public var currentDate = Date()
    public var lastChecked: Date?

    public var isChecked: Bool {
        get {
            lastChecked != nil
        }
        set {
            if newValue {
                lastChecked = Date()
                currentDate = Date()
            } else {
                lastChecked = nil
            }
        }
    }

    public mutating func toggle() {
        currentDate = Date()
        guard lastChecked == nil else {
            lastChecked = nil
            return
        }
        lastChecked = Date()
    }

    public init(title: String, detail: String = "", lastChecked: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.lastChecked = lastChecked
    }
}
