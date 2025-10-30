import Foundation
import SwiftUI

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

    // 计算属性：状态颜色
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public var statusColor: Color {
        switch status {
        case .checked:
            return Color.green
        case .partiallyChecked:
            return Color.orange
        case .unchecked:
            return Color.secondary.opacity(0.5)
        }
    }

    // 计算属性：已完成的任务数量
    public var checkedCount: Int {
        items.filter { $0.lastChecked != nil }.count
    }

    public var checkedVsTotal: String {
        "\(checkedCount)/\(items.count)"
    }

    public var checkRatio: Double {
        Double(checkedCount) / Double(items.count)
    }

    public init(name: String, items: [AChecklistItem]) {
        self.id = UUID()
        self.name = name
        self.items = items
    }
}
