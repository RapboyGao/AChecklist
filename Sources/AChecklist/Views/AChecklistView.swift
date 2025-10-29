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
            backgroundColor: .white,
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

    public var body: some View {
        ZStack {
            // 根据操作系统选择合适的背景
                #if os(tvOS)
                checklistStyle.backgroundColor.ignoresSafeArea()
                #elseif os(macOS)
                checklistStyle.backgroundColor.ignoresSafeArea()
                #elseif os(watchOS)
                checklistStyle.backgroundColor.ignoresSafeArea()
                #else
                // iOS 使用渐变背景
                LinearGradient(
                    gradient: Gradient(colors: [checklistStyle.backgroundColor, checklistStyle.secondaryColor]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                #endif
            
            // 主要内容滚动视图
            ScrollView(
                showsIndicators: false,
                content: {
                    VStack(alignment: .leading, spacing: checklistStyle.sectionSpacing) {
                        // 标题和统计信息
                        VStack(alignment: .leading, spacing: 8) {
                            Text(checklist.name)
                                .font(checklistStyle.titleFont)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .opacity(isViewAppearing ? 0 : 1)
                                .offset(y: isViewAppearing ? -20 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: isViewAppearing)
                            
                            HStack(spacing: 24) {
                                // 总任务数
                                HStack(spacing: 4) {
                                    Image(systemName: "list.bullet")
                                        .foregroundColor(.secondary)
                                    Text("\(totalItems)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .opacity(isViewAppearing ? 0 : 1)
                                .offset(y: isViewAppearing ? -20 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: isViewAppearing)
                                
                                // 已完成任务数
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.green)
                                    Text("\(completedItems)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .opacity(isViewAppearing ? 0 : 1)
                                .offset(y: isViewAppearing ? -20 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: isViewAppearing)
                                
                                // 完成进度百分比
                                if totalItems > 0 {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chart.bar")
                                            .foregroundColor(progressColor)
                                        Text("\(progressPercentage)%")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(progressColor)
                                    }
                                    .opacity(isViewAppearing ? 0 : 1)
                                    .offset(y: isViewAppearing ? -20 : 0)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.4), value: isViewAppearing)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 8)
                        
                        // 主要进度条
                        if totalItems > 0 {
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.secondary.opacity(0.1))
                                    .frame(height: 8)
                                    .overlay(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(progressColor)
                                            .frame(
                                                width: geometry.size.width * CGFloat(progressPercentage) / 100,
                                                height: 8
                                            )
                                            .opacity(isViewAppearing ? 0 : 1)
                                            .offset(x: isViewAppearing ? -20 : 0)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5), value: isViewAppearing)
                                    }
                            }
                            .frame(height: 8)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                        }
                        
                        // 区域列表
                        VStack(alignment: .leading, spacing: checklistStyle.sectionSpacing) {
                            ForEach($checklist.sections) { $section in
                                AChecklistSectionView(section: $section)
                                    .opacity(isViewAppearing ? 0 : 1)
                                    .offset(y: isViewAppearing ? 20 : 0)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.7)
                                            .delay(0.2 + Double(checklist.sections.firstIndex(where: { $0.id == section.id }) ?? 0) * 0.1),
                                        value: isViewAppearing
                                    )
                            }
                        }
                        
                        // 底部间距
                        Spacer(minLength: checklistStyle.padding * 2)
                    }
                }
            )
        }
        .navigationTitle(checklist.name)
        #if os(iOS) || os(tvOS) || os(watchOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        #if os(macOS)
        .frame(minWidth: 400, minHeight: 400) // macOS 最小窗口尺寸
        #endif
        .onAppear {
            // 视图出现时的动画
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isViewAppearing = false
                }
            }
        }
    }
    
    // 计算属性：总任务数
    private var totalItems: Int {
        checklist.sections.reduce(0) { $0 + $1.items.count }
    }
    
    // 计算属性：已完成任务数
    private var completedItems: Int {
        checklist.sections.reduce(0) { $0 + $1.items.filter { $0.lastChecked != nil }.count }
    }
    
    // 计算属性：进度百分比
    private var progressPercentage: Int {
        guard totalItems > 0 else { return 0 }
        return Int(Double(completedItems) / Double(totalItems) * 100)
    }
    
    // 计算属性：进度条颜色
    private var progressColor: Color {
        switch progressPercentage {
        case 100:
            return .green
        case 50 ... 99:
            return .orange
        default:
            return .blue
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
    @State var checklist = AChecklist(name: "检查单1", sections: [
        AChecklistSection(name: "任务", items: [
            AChecklistItem(title: "手电筒", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: "电池", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: "手电筒", detail: "充电后注意查看指示灯"),
        ]),
        AChecklistSection(name: "其他", items: [
            AChecklistItem(title: "充电器", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: "电池", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: "手电筒", detail: "充电后注意查看指示灯"),
        ]),
    ])

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
