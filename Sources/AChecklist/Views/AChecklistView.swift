import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistView: View {
    // 根据不同操作系统提供不同的样式配置
    private var checklistStyle: ChecklistStyle {
        #if os(iOS)
            return ChecklistStyle(
                cornerRadius: 16,
                padding: 16,
                titleFont: .largeTitle,
                sectionSpacing: 20,
                contentPadding: 16,
                backgroundColor: .white,
                secondaryColor: Color.gray.opacity(0.1)
            )
        #elseif os(macOS)
            return ChecklistStyle(
                cornerRadius: 10,
                padding: 20,
                titleFont: .system(size: 28, weight: .bold),
                sectionSpacing: 16,
                contentPadding: 12,
                backgroundColor: Color(.windowBackgroundColor),
                secondaryColor: Color(.controlBackgroundColor)
            )
        #elseif os(tvOS)
            return ChecklistStyle(
                cornerRadius: 20,
                padding: 24,
                titleFont: .system(size: 40, weight: .heavy),
                sectionSpacing: 28,
                contentPadding: 20,
                backgroundColor: .black,
                secondaryColor: Color.gray.opacity(0.2)
            )
        #elseif os(watchOS)
            return ChecklistStyle(
                cornerRadius: 10,
                padding: 12,
                titleFont: .title,
                sectionSpacing: 12,
                contentPadding: 8,
                backgroundColor: .black,
                secondaryColor: Color.gray.opacity(0.1)
            )
        #else
            // 默认样式
            return ChecklistStyle(
                cornerRadius: 12,
                padding: 16,
                titleFont: .largeTitle,
                sectionSpacing: 16,
                contentPadding: 12,
                backgroundColor: .white,
                secondaryColor: Color.gray.opacity(0.1)
            )
        #endif
    }

    private struct ChecklistStyle {
        let cornerRadius: CGFloat
        let padding: CGFloat
        let titleFont: Font
        let sectionSpacing: CGFloat
        let contentPadding: CGFloat
        let backgroundColor: Color
        let secondaryColor: Color
    }

    @Binding var checklist: AChecklist
    @State private var isViewAppearing = true
    
    /// 检查互斥组中是否有已选中的section
    /// - Parameter section: 当前要检查的section
    /// - Returns: (是否有已选中的互斥section, 是否应该禁用当前section)
    private func checkMutualExclusion(for section: AChecklistSection) -> (hasActiveSection: Bool, shouldDisable: Bool) {
        // 只处理互斥section
        guard section.isMutualExclusion else {
            return (false, false)
        }
        
        // 查找当前section所在的互斥组
        var mutualExclusionGroup = [AChecklistSection]()
        var inMutualGroup = false
        
        for s in checklist.sections {
            if s.isMutualExclusion {
                inMutualGroup = true
                mutualExclusionGroup.append(s)
                // 如果找到当前section，记录位置但继续收集整个互斥组
                if s.id == section.id {
                    continue
                }
            } else if inMutualGroup {
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
    
    /// 当互斥组中选中一个section时，重置其他section
    /// - Parameter selectedSection: 被选中的section
    private func handleMutualExclusionSelection(for selectedSection: AChecklistSection) {
        guard selectedSection.isMutualExclusion && selectedSection.status != .unchecked else {
            return
        }
        
        // 查找并处理整个互斥组
        var isInTargetGroup = false
        
        for index in checklist.sections.indices {
            let currentSection = checklist.sections[index]
            
            if currentSection.isMutualExclusion {
                isInTargetGroup = true
                // 重置除了当前选中section以外的其他互斥section
                if currentSection.id != selectedSection.id {
                    checklist.sections[index].status = .unchecked
                }
            } else if isInTargetGroup {
                // 已经处理完整个互斥组
                break
            }
        }
    }

    public var body: some View {
        // 主要内容滚动视图
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: checklistStyle.sectionSpacing) {
                // 区域列表
                VStack(alignment: .leading, spacing: checklistStyle.sectionSpacing) {
                    ForEach($checklist.sections) { $section in
                        let (_, shouldDisable) = checkMutualExclusion(for: section)
                        AChecklistSectionView(section: $section)
                            .opacity(isViewAppearing ? 0 : (shouldDisable ? 0.7 : 1.0))
                            .offset(y: isViewAppearing ? 20 : 0)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.7)
                                    .delay(0.2 + Double(checklist.sections.firstIndex(where: { $0.id == section.id }) ?? 0) * 0.1),
                                value: isViewAppearing
                            )
                            .disabled(shouldDisable)
                            .onChange(of: section.status) { _ in
                                // 当section状态改变时，处理互斥逻辑
                                handleMutualExclusionSelection(for: section)
                            }
                    }
                }
            }
        }
        .navigationTitle(checklist.name)
        .onAppear {
            // 视图出现时的动画
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isViewAppearing = false
                }
            }
        }
        #if os(iOS) || os(tvOS) || os(watchOS)
        .navigationBarTitleDisplayMode(.large)
        #elseif os(macOS)
        .frame(minWidth: 400, minHeight: 400) // macOS 最小窗口尺寸
        #endif
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
    @State var checklist: AChecklist = .example

    var body: some View {
        AChecklistView(checklist: $checklist)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Example()
        }
    }
}
