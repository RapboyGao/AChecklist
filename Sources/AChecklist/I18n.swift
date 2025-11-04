import Foundation

enum I18n {
  public static let mutualExclusion = NSLocalizedString(
    "@mutualExclusion",
    bundle: .module, comment: "AChecklistSectionEditView 中 MutualExclusion 开关的标签文字")

  public static let checklistItem = NSLocalizedString(
    "@checklistItem",
    bundle: .module, comment: "AChecklistItemEditView 的标题")

  public static let checklistItemDetail = NSLocalizedString(
    "@checklistItemDetail",
    bundle: .module, comment: "AChecklistItemEditView 中默认的详情文字")

  /// 启用 MutualExclusion 后，同一 Checklist 内相邻 Section 将互斥，仅允许选择其中一组
  public static let mutualExclusionExplanation = NSLocalizedString(
    "@mutualExclusionExplanation",
    bundle: .module, comment: "AChecklistSectionEditView 中解释什么是 MutualExclusion 的描述性文字")

  public static let second = NSLocalizedString(
    "@second",
    bundle: .module, comment: "AChecklistItemEditView 中设置秒数的标签文字(单数形式)")

  public static let seconds = NSLocalizedString(
    "@seconds",
    bundle: .module, comment: "AChecklistItemEditView 中设置秒数的标签文字(复数形式)")

  public static let minute = NSLocalizedString(
    "@minute",
    bundle: .module, comment: "AChecklistItemEditView 中设置分钟数的标签文字(单数形式)")

  public static let expiresAfter = NSLocalizedString(
    "@expiresAfter",
    bundle: .module, comment: "AChecklistItemEditView 中设置过期时间的Section标题")

  public static let minutes = NSLocalizedString(
    "@minutes",
    bundle: .module, comment: "AChecklistItemEditView 中设置分钟数的标签文字(复数形式)")

  public static let hour = NSLocalizedString(
    "@hour",
    bundle: .module, comment: "AChecklistItemEditView 中设置小时数的标签文字(单数形式)")

  public static let hours = NSLocalizedString(
    "@hours",
    bundle: .module, comment: "AChecklistItemEditView 中设置小时数的标签文字(复数形式)")

  public static let day = NSLocalizedString(
    "@day",
    bundle: .module, comment: "AChecklistItemEditView 中设置天数的标签文字(单数形式)")

  public static let days = NSLocalizedString(
    "@days",
    bundle: .module, comment: "AChecklistItemEditView 中设置天数的标签文字(复数形式)")

  public static let week = NSLocalizedString(
    "@week",
    bundle: .module, comment: "AChecklistItemEditView 中设置周数的标签文字(单数形式)")

  public static let weeks = NSLocalizedString(
    "@weeks",
    bundle: .module, comment: "AChecklistItemEditView 中设置周数的标签文字(复数形式)")

  public static let month = NSLocalizedString(
    "@month",
    bundle: .module, comment: "AChecklistItemEditView 中设置月数的标签文字(单数形式)")

  public static let months = NSLocalizedString(
    "@months",
    bundle: .module, comment: "AChecklistItemEditView 中设置月数的标签文字(复数形式)")

  public static let year = NSLocalizedString(
    "@year",
    bundle: .module, comment: "AChecklistItemEditView 中设置年数的标签文字(单数形式)")

  public static let years = NSLocalizedString(
    "@years",
    bundle: .module, comment: "AChecklistItemEditView 中设置年数的标签文字(复数形式)")
}
