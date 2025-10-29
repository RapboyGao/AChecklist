import Foundation

public struct AChecklistItem: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var title: String
    public var detail: String
    public var lastChecked: Date?

    public mutating func toggle() {
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
