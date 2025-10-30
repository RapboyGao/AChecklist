import Foundation

public enum I18n {
  public static let mutualExclusion = NSLocalizedString(
    "@mutualExclusion",
    bundle: .module, comment: "AChecklistSectionEditView 中 MutualExclusion 开关的标签文字")

  /// 启用 MutualExclusion 后，同一 Checklist 内相邻 Section 将互斥，仅允许选择其中一组
  public static let mutualExclusionExplanation = NSLocalizedString(
    "@mutualExclusionExplanation",
    bundle: .module, comment: "AChecklistSectionEditView 中解释什么是 MutualExclusion 的描述性文字")
}
