// The Swift Programming Language
// https://docs.swift.org/swift-book
import CoreTransferable
import Foundation
import CryptoKit

public struct AChecklist: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var name: String
    public var sections: [AChecklistSection]
    
    /// 检查单的状态
    /// 考虑互斥section的情况：连续的isMutualExclusion为true的section组中，若有且只有1个为checked，则该组视为完成
    public var status: AChecklistStatus {
        get {
            // 处理互斥section组
            var groupedSections = [[AChecklistSection]]()
            var currentGroup = [AChecklistSection]()
            
            for section in sections {
                if section.isMutualExclusion {
                    // 添加到当前互斥组
                    currentGroup.append(section)
                } else {
                    // 非互斥section，将之前的互斥组添加到分组列表
                    if !currentGroup.isEmpty {
                        groupedSections.append(currentGroup)
                        currentGroup = []
                    }
                    // 将非互斥section单独作为一组
                    groupedSections.append([section])
                }
            }
            
            // 处理最后一个互斥组
            if !currentGroup.isEmpty {
                groupedSections.append(currentGroup)
            }
            
            // 检查每个组是否完成
            var allGroupsCompleted = true
            var anyGroupStarted = false
            
            for group in groupedSections {
                if group.count == 1 && !group[0].isMutualExclusion {
                    // 单个非互斥section
                    let sectionStatus = group[0].status
                    if sectionStatus != .checked {
                        allGroupsCompleted = false
                    }
                    if sectionStatus != .unchecked {
                        anyGroupStarted = true
                    }
                } else {
                    // 互斥section组
                    let checkedCount = group.filter { $0.status == .checked }.count
                    if checkedCount != 1 {
                        allGroupsCompleted = false
                    }
                    if checkedCount > 0 {
                        anyGroupStarted = true
                    }
                }
            }
            
            // 确定整体状态
            if allGroupsCompleted {
                return .checked
            } else if anyGroupStarted {
                return .partiallyChecked
            } else {
                return .unchecked
            }
        }
        set {
            switch newValue {
            case .checked:
                // 设置所有section为checked
                for index in sections.indices {
                    sections[index].status = .checked
                }
            case .unchecked:
                // 设置所有section为unchecked
                for index in sections.indices {
                    sections[index].status = .unchecked
                }
            case .partiallyChecked:
                // 部分选中状态不做处理
                break
            }
        }
    }

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
