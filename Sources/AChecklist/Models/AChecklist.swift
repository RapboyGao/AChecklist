// The Swift Programming Language
// https://docs.swift.org/swift-book
import CoreTransferable
import CryptoKit
import Foundation
import SwiftUI

public struct AChecklist: Codable, Sendable, Hashable, Identifiable {
  public var id: UUID
  public var name: String
  public var sections: [AChecklistSection]

  mutating func removeSection(id: UUID) {
    sections.removeAll { section in
      section.id == id
    }
  }

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
        }
        else {
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
        }
        else {
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
      }
      else if anyGroupStarted {
        return .partiallyChecked
      }
      else {
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

  /// 检查互斥组中是否有已选中的section
  /// - Parameter section: 当前要检查的section
  /// - Returns: (是否有已选中的互斥section, 是否应该禁用当前section)
  public func checkMutualExclusion(for section: AChecklistSection) -> (
    hasActiveSection: Bool, shouldDisable: Bool
  ) {
    // 只处理互斥section
    guard section.isMutualExclusion else {
      return (false, false)
    }

    // 查找当前section所在的互斥组
    var mutualExclusionGroup = [AChecklistSection]()
    var inMutualGroup = false

    for s in sections {
      if s.isMutualExclusion {
        inMutualGroup = true
        mutualExclusionGroup.append(s)
        // 如果找到当前section，记录位置但继续收集整个互斥组
        if s.id == section.id {
          continue
        }
      }
      else if inMutualGroup {
        // 遇到非互斥section，结束当前互斥组的收集
        break
      }
    }

    // 检查互斥组中是否有非unchecked状态的section
    let hasActiveSection = mutualExclusionGroup.contains {
      $0.id != section.id && $0.status != .unchecked
    }

    return (hasActiveSection, hasActiveSection)
  }

  /// 重置所有section的状态为unchecked
  public mutating func resetAllSections() {
    for index in sections.indices {
      sections[index].status = .unchecked
    }
  }

  /// 当互斥组中选中一个section时，重置其他section
  /// - Parameter selectedSection: 被选中的section
  public mutating func handleMutualExclusionSelection(for selectedSection: AChecklistSection) {
    guard selectedSection.isMutualExclusion && selectedSection.status != .unchecked else {
      return
    }

    // 查找并处理整个互斥组
    var isInTargetGroup = false

    for index in sections.indices {
      let currentSection = sections[index]

      if currentSection.isMutualExclusion {
        isInTargetGroup = true
        // 重置除了当前选中section以外的其他互斥section
        if currentSection.id != selectedSection.id {
          sections[index].status = .unchecked
        }
      }
      else if isInTargetGroup {
        // 已经处理完整个互斥组
        break
      }
    }
  }

  /// 示例检查单数据
  /// 包含5个正常组和3个连续的互斥组
  public static let example = AChecklist(
    name: "综合检查单示例",
    sections: [
      // 正常组1: 准备工作
      AChecklistSection(
        name: "准备工作",
        items: [
          AChecklistItem(title: "检查设备电量", detail: "确保所有设备电量充足"),
          AChecklistItem(title: "准备工具包", detail: "包括螺丝刀、万用表等基础工具"),
          AChecklistItem(title: "阅读操作手册", detail: "熟悉设备操作流程"),
        ]
      ),
      // 正常组2: 系统检查
      AChecklistSection(
        name: "系统检查",
        items: [
          AChecklistItem(
            title: "启动操作系统", detail: "确认系统正常运行", lastChecked: Date(timeIntervalSinceNow: -3600 * 10)
          ),
          AChecklistItem(title: "检查网络连接", detail: "确保网络稳定可用"),
          AChecklistItem(title: "验证账户权限", detail: "确认拥有必要的操作权限"),
        ]
      ),
      // 正常组3: 数据备份
      AChecklistSection(
        name: "数据备份",
        items: [
          AChecklistItem(title: "备份关键数据", detail: "确保所有重要数据已备份"),
          AChecklistItem(title: "验证备份完整性", detail: "检查备份文件是否可恢复"),
          AChecklistItem(title: "记录备份时间", detail: "更新备份日志"),
        ]
      ),
      // 互斥组1: 连接方式选择（互斥组）
      AChecklistSection(
        name: "有线连接",
        items: [
          AChecklistItem(title: "连接USB线缆", detail: "使用高速USB 3.0线缆"),
          AChecklistItem(title: "安装驱动程序", detail: "确保驱动正确安装"),
          AChecklistItem(title: "测试数据传输", detail: "验证连接稳定性"),
        ]
      )
      .mutating { $0.isMutualExclusion = true },
      // 互斥组2: 连接方式选择（互斥组）
      AChecklistSection(
        name: "无线连接",
        items: [
          AChecklistItem(title: "启用Wi-Fi", detail: "连接到指定网络"),
          AChecklistItem(title: "配置IP地址", detail: "使用静态或DHCP分配"),
          AChecklistItem(title: "测试连接速度", detail: "确保满足性能要求"),
        ]
      )
      .mutating { $0.isMutualExclusion = true },
      // 互斥组3: 连接方式选择（互斥组）
      AChecklistSection(
        name: "蓝牙连接",
        items: [
          AChecklistItem(title: "启用蓝牙", detail: "确保设备蓝牙可见"),
          AChecklistItem(title: "配对设备", detail: "完成蓝牙配对过程"),
          AChecklistItem(title: "验证连接质量", detail: "检查信号强度和稳定性"),
        ]
      )
      .mutating { $0.isMutualExclusion = true },
      // 正常组4: 配置设置
      AChecklistSection(
        name: "配置设置",
        items: [
          AChecklistItem(title: "设置基本参数", detail: "根据需求调整系统参数"),
          AChecklistItem(title: "配置用户偏好", detail: "设置显示、语言等偏好"),
          AChecklistItem(title: "保存配置文件", detail: "导出当前配置以备后用"),
        ]
      ),
      // 正常组5: 最终测试
      AChecklistSection(
        name: "最终测试",
        items: [
          AChecklistItem(title: "执行功能测试", detail: "验证所有功能正常工作"),
          AChecklistItem(title: "检查错误日志", detail: "确认没有异常错误"),
          AChecklistItem(title: "完成验收报告", detail: "记录测试结果"),
        ]
      ),
    ]
  )

  public static let mutualExclusionExplanation = AChecklist(
    name: I18n.mutualExclusionExplanationExampleChecklistName,
    sections: [
      AChecklistSection(
        name: I18n.defaultSectionExampleName1,
        items: [.createRandom().noDetail()]
      ),
      AChecklistSection(
        name: I18n.mutualExclusionExampleSectionName1,
        items: [
          .init(title: I18n.mutualExclusion, detail: I18n.mutualExclusionExplanation),
          .createRandom().noDetail(),
        ]
      )
      .mutating { $0.isMutualExclusion = true },
      AChecklistSection(
        name: I18n.mutualExclusionExampleSectionName2,
        items: [.createRandom().noDetail(), .createRandom().noDetail()]
      )
      .mutating { $0.isMutualExclusion = true },
      AChecklistSection(
        name: I18n.defaultSectionExampleName2,
        items: [.createRandom().noDetail()]
      ),
    ]
  )

  public init?(data: Data?) {
    guard let data = data else {
      return nil
    }
    let decoder = JSONDecoder()
    guard let decoded = try? decoder.decode(AChecklist.self, from: data) else {
      return nil
    }
    self = decoded
  }
}

// 扩展用于在创建时直接修改属性
extension AChecklistSection {
  @discardableResult
  fileprivate func mutating(_ mutation: (inout Self) -> Void) -> Self {
    var mutableSelf = self
    mutation(&mutableSelf)
    return mutableSelf
  }
}
