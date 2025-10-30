import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistSectionView: View {
    // 根据不同操作系统提供不同的样式配置
    private var sectionStyle: SectionStyle {
        #if os(iOS)
            return SectionStyle(
                cornerRadius: 12,
                padding: 16,
                titleFont: .headline,
                subtitleFont: .caption2,
                verticalSpacing: 8,
                horizontalSpacing: 12,
                sidebarWidth: 8
            )
        #elseif os(macOS)
            return SectionStyle(
                cornerRadius: 8,
                padding: 12,
                titleFont: .system(size: 15, weight: .semibold),
                subtitleFont: .system(size: 11),
                verticalSpacing: 6,
                horizontalSpacing: 10,
                sidebarWidth: 6
            )
        #elseif os(tvOS)
            return SectionStyle(
                cornerRadius: 16,
                padding: 20,
                titleFont: .system(size: 24, weight: .bold),
                subtitleFont: .system(size: 14),
                verticalSpacing: 12,
                horizontalSpacing: 16,
                sidebarWidth: 10
            )
        #elseif os(watchOS)
            return SectionStyle(
                cornerRadius: 8,
                padding: 10,
                titleFont: .headline,
                subtitleFont: .caption2,
                verticalSpacing: 5,
                horizontalSpacing: 8,
                sidebarWidth: 6
            )
        #else
            // 默认样式
            return SectionStyle(
                cornerRadius: 10,
                padding: 14,
                titleFont: .headline,
                subtitleFont: .caption2,
                verticalSpacing: 8,
                horizontalSpacing: 12,
                sidebarWidth: 8
            )
        #endif
    }

    private struct SectionStyle {
        let cornerRadius: CGFloat
        let padding: CGFloat
        let titleFont: Font
        let subtitleFont: Font
        let verticalSpacing: CGFloat
        let horizontalSpacing: CGFloat
        let sidebarWidth: CGFloat
    }

    @Binding var section: AChecklistSection

    public var body: some View {
        // 主容器，包含左侧的完整竖条
        HStack(alignment: .top, spacing: 0) {
            // 左侧竖条 - 根据完成程度变色，从标题栏延续到所有任务项
            RoundedRectangle(cornerRadius: sectionStyle.sidebarWidth / 2)
                .frame(width: sectionStyle.sidebarWidth)
                .foregroundColor(section.statusColor)
                .animation(.easeInOut(duration: 0.5), value: section.checkedCount)
                .padding(.top, sectionStyle.padding / 2) // 与标题栏对齐
                .padding(.bottom, sectionStyle.padding) // 底部留空

            // 内容区域
            VStack(alignment: .leading, spacing: 0) {
                // 区域标题栏
                Button(action: {
                    // 切换全选/取消全选状态
                    withAnimation {
                        switch section.status {
                        case .checked:
                            // 如果全部选中或部分选中，则取消全选
                            section.status = .unchecked
                        case .unchecked, .partiallyChecked:
                            // 如果未选中，则全选
                            section.status = .checked
                        }
                    }
                }) {
                    HStack(alignment: .center, spacing: sectionStyle.horizontalSpacing) {
                        // 标题和计数 - 设置为可点击以实现全选/取消全选
                        VStack(alignment: .leading, spacing: 2) {
                            Text(section.name)
                                .font(sectionStyle.titleFont)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.vertical, 2) // 增加点击区域

                            // 进度指示器
                            HStack(spacing: 10) {
                                Text(section.checkedVsTotal)
                                    .font(sectionStyle.subtitleFont)
                                    .foregroundColor(.secondary)

                                // 小型进度条
                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.secondary.opacity(0.2))
                                        .frame(height: 4)
                                        .overlay(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 3)
                                                .fill(section.statusColor)
                                                .frame(
                                                    width: section.items.isEmpty ? 0 :
                                                        geometry.size.width * section.checkRatio,
                                                    height: 4
                                                )
                                                .animation(.easeInOut(duration: 0.5), value: section.checkedCount)
                                        }
                                }
                                .frame(height: 4)
                            }
                        }

                        Spacer()
                    }
                    .padding(sectionStyle.padding)
                    .background(.thickMaterial)
                    .cornerRadius(sectionStyle.cornerRadius)
                    .padding(.bottom, sectionStyle.verticalSpacing)
                    #if os(macOS)
                        .onHover { isHovering in
                            // macOS hover效果通过修改透明度实现
                            if isHovering {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    // 这里可以通过状态变量来控制hover效果
                                }
                            }
                        }
                    #endif
                }
                .buttonStyle(.plain) // 保持文字样式不变
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: section.status)

                // 任务列表
                VStack(alignment: .leading, spacing: sectionStyle.verticalSpacing + 2) {
                    ForEach($section.items) { $item in
                        // 直接显示项目内容，不再包含单独的竖条
                        AChecklistItemView(item: $item)
                            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: item)
                    }
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, sectionStyle.horizontalSpacing) // 内容区域内边距
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
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
