import Foundation

enum I18n {
  public static let mutualExclusion = NSLocalizedString(
    "@mutualExclusion",
    bundle: .module, comment: "AChecklistSectionEditView 中 MutualExclusion 开关的标签文字 '互斥组'")

  public static let mutualExclusionExplanationExampleChecklistName = NSLocalizedString(
    "@mutualExclusionExplanationExampleChecklistName",
    bundle: .module, comment: "用于展示mutual Exclusion和默认分区的区别的AChecklist的标题，‘互斥分区示例’")

  /// 未启用 MutualExclusion 时的默认示例分区标题1，‘默认分区1’
  public static let defaultSectionExampleName1 = NSLocalizedString(
    "@defaultSectionExampleName1",
    bundle: .module, comment: "AChecklistSection 中未启用 MutualExclusion 时的默认示例分区标题1，‘默认分区1’")

  /// 未启用 MutualExclusion 时的默认示例分区标题2，‘默认分区2’
  public static let defaultSectionExampleName2 = NSLocalizedString(
    "@defaultSectionExampleName2",
    bundle: .module, comment: "AChecklistSection 中未启用 MutualExclusion 时的默认示例分区标题2，‘默认分区2’")
  /// 启用 MutualExclusion 后，同一 Checklist 内相邻 Section 将互斥，仅允许选择其中一组
  /// 互斥分区1，‘互斥分区1’
  public static let mutualExclusionExampleSectionName1 = NSLocalizedString(
    "@mutualExclusionExampleSectionName1",
    bundle: .module, comment: "AChecklistSection 中 MutualExclusion 为true示例分区1标题，‘互斥分区1’")
  /// 启用 MutualExclusion 后，同一 Checklist 内相邻 Section 将互斥，仅允许选择其中一组
  /// 互斥分区2，‘互斥分区2’
  public static let mutualExclusionExampleSectionName2 = NSLocalizedString(
    "@mutualExclusionExampleSectionName2",
    bundle: .module, comment: "AChecklistSection 中 MutualExclusion 为true示例分区2标题，‘互斥分区2’")

  public static let checklistItem = NSLocalizedString(
    "@checklistItem",
    bundle: .module, comment: "AChecklistItemEditView 的标题，‘检查项’")

  public static let checklistItemDetail = NSLocalizedString(
    "@checklistItemDetail",
    bundle: .module, comment: "AChecklistItemEditView 中默认的详情文字")
  //
  public static let confirmDeleteSection = NSLocalizedString(
    "@confirmDeleteSection",
    bundle: .module, comment: "AChecklistSectionEditView 中确认删除分区的确认对话框文字 \"确定要删除这部分吗？此操作无法撤销。\"")

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
