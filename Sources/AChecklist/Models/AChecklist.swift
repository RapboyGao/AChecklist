// The Swift Programming Language
// https://docs.swift.org/swift-book
import CoreTransferable
import Foundation
import CryptoKit

public struct AChecklist: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var name: String
    public var sections: [AChecklistSection]

    public init(name: String, sections: [AChecklistSection]) {
        self.id = UUID()
        self.name = name
        self.sections = sections
    }

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    public func toEncryptedData() -> Data? {
        let data = try? JSONEncoder().encode(self)
        guard let data = data else { return nil }
        let key = SymmetricKey(size: .bits256)
        let sealedBox = try? AES.GCM.seal(data, using: key)
        return sealedBox?.combined
    }
}
