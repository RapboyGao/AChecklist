// The Swift Programming Language
// https://docs.swift.org/swift-book
import CoreTransferable
import Foundation

public struct AChecklist: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var name: String
    public var sections: [AChecklistSection]
}
