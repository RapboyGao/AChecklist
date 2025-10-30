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
    
    // 互斥处理逻辑已移至AChecklist模型中

    public var body: some View {
        // 主要内容滚动视图
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: checklistStyle.sectionSpacing) {
                // 区域列表
                VStack(alignment: .leading, spacing: checklistStyle.sectionSpacing) {
                    ForEach($checklist.sections) { $section in
                        let (_, shouldDisable) = checklist.checkMutualExclusion(for: section)
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
                                checklist.handleMutualExclusionSelection(for: section)
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
