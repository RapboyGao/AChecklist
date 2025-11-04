import Foundation

public struct AChecklistItem: Codable, Sendable, Hashable, Identifiable {
  public var id: UUID
  public var title: String
  public var detail: String

  public var currentDate = Date()
  public var lastChecked: Date?
  public var expiresAfter: DateComponents = DateComponents(hour: 6)

  public func isExpired(now: Date) -> Bool {
    guard let lastChecked else { return false }
    let calendar = Calendar.current
    let expiresDate = calendar.date(byAdding: expiresAfter, to: lastChecked) ?? Date.distantFuture
    return expiresDate < now
  }

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

  public static func createRandom() -> Self {
    // 取最前面5位
    let id: Substring = UUID().uuidString.prefix(5)
    return AChecklistItem(title: "Item-\(id)", detail: "Detail", lastChecked: nil)
  }

  public init(title: String, detail: String = "", lastChecked: Date? = nil) {
    self.id = UUID()
    self.title = title
    self.detail = detail
    self.lastChecked = lastChecked
  }
}
