import Foundation

public struct AChecklistSection: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var name: String
    public var items: [AChecklistItem]
}
