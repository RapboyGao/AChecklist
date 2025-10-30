import Foundation

public struct AChecklistItem: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var title: String
    public var detail: String
    public var currentDate = Date()
    public var lastChecked: Date?

    public var detailIsEmpty: Bool {
        detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var isChecked: Bool {
        get {
            lastChecked != nil
        }
        set {
            if newValue {
                currentDate = Date(timeIntervalSinceNow: 1)
                lastChecked = Date()
            } else {
                lastChecked = nil
            }
        }
    }

    public mutating func toggle() {
        currentDate = Date(timeIntervalSinceNow: 1)

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
