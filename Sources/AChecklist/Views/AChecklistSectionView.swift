import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistSectionView: View {
    @Binding var section: AChecklistSection

    public var body: some View {
        // 主容器，包含左侧的完整竖条
        HStack(alignment: .top, spacing: 0) {
            // 左侧竖条 - 根据完成程度变色，从标题栏延续到所有任务项
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 8)
                .foregroundColor(statusColor)
                .animation(.easeInOut(duration: 0.5), value: checkedCount)
                .padding(.top, 8) // 与标题栏对齐
                .padding(.bottom, 16) // 底部留空
            
            // 内容区域
            VStack(alignment: .leading, spacing: 0) {
                // 区域标题栏
                HStack(alignment: .center, spacing: 12) {
                    // 标题和计数 - 设置为可点击以实现全选/取消全选
                    VStack(alignment: .leading, spacing: 2) {
                        Button(action: {
                            // 切换全选/取消全选状态
                            withAnimation {
                                switch section.status {
                                case .checked, .partiallyChecked:
                                    // 如果全部选中或部分选中，则取消全选
                                    section.status = .unchecked
                                case .unchecked:
                                    // 如果未选中，则全选
                                    section.status = .checked
                                }
                            }
                        }) {        
                            Text(section.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.vertical, 2) // 增加点击区域
                        }
                        .buttonStyle(.plain) // 保持文字样式不变
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: section.status)
                        
                        // 进度指示器
                        HStack(spacing: 4) {
                            Text("\(checkedCount)/\(section.items.count)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            // 小型进度条
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.secondary.opacity(0.2))
                                    .frame(height: 4)
                                    .overlay(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(statusColor)
                                            .frame(
                                                width: section.items.isEmpty ? 0 : 
                                                    geometry.size.width * CGFloat(checkedCount) / CGFloat(section.items.count),
                                                height: 4
                                            )
                                            .animation(.easeInOut(duration: 0.5), value: checkedCount)
                                    }
                            }
                            .frame(height: 4)
                            .frame(maxWidth: 80)
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.bottom, 8)
                
                // 任务列表
                VStack(alignment: .leading, spacing: 10) {
                    ForEach($section.items) { $item in
                        // 直接显示项目内容，不再包含单独的竖条
                        AChecklistItemView(item: $item)
                            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: item)
                    }
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 12) // 内容区域内边距
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // 计算属性：已完成的任务数量
    private var checkedCount: Int {
        section.items.filter { $0.lastChecked != nil }.count
    }
    
    // 计算属性：状态颜色
    private var statusColor: Color {
        switch section.status {
        case .checked:
            return .green
        case .partiallyChecked:
            return .orange
        case .unchecked:
            return .secondary.opacity(0.5)
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
    @State var section = AChecklistSection(name: "任务", items: [
        AChecklistItem(title: "手电筒", detail: "充电后注意查看指示灯"),
        AChecklistItem(title: "电池", detail: "充电后注意查看指示灯"),
        AChecklistItem(title: "手电筒", detail: "充电后注意查看指示灯"),
    ])

    var body: some View {
        AChecklistSectionView(section: $section)
            .padding()
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Example()
    }
}
