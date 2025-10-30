import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistSectionView: View {
    @Binding var section: AChecklistSection
    var checkMutualExclusion:
        ((AChecklistSection) -> (hasActiveSection: Bool, shouldDisable: Bool))? =
            nil

    var shouldDisable: Bool {
        checkMutualExclusion?(section).shouldDisable ?? false
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            sidebarView
            contentAreaView
        }
        .disabled(shouldDisable)
        .padding(.horizontal, sectionStyle.horizontalSpacing)
        .padding(.vertical, 8)
    }

    /// 侧边栏视图
    /// 包含在 body 中
    private var sidebarView: some View {
        RoundedRectangle(cornerRadius: sectionStyle.sidebarWidth / 2)
            .frame(width: sectionStyle.sidebarWidth)
            .foregroundColor(section.statusColor)
            .animation(.easeInOut(duration: 0.5), value: section.checkedCount)
            .padding(.top, sectionStyle.padding / 2)  // 与标题栏对齐
            .padding(.bottom, sectionStyle.padding)  // 底部留空
    }

    /// 内容区域视图
    /// 包含在 body 中
    private var contentAreaView: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeaderView
            itemsListView
        }
        #if os(watchOS)
            .padding(.leading, sectionStyle.horizontalSpacing)  // 内容区域内边距
        #else
            .padding(.horizontal, sectionStyle.horizontalSpacing)  // 内容区域内边距
        #endif
    }

    /// 区域标题栏视图
    /// 包含在 contentAreaView 中
    private var sectionHeaderView: some View {
        return Button {
            withAnimation {
                section.toggle()
            }
        } label: {
            HStack(alignment: .center, spacing: sectionStyle.horizontalSpacing)
            {
                headerContent
                Spacer()
            }
            .padding(sectionStyle.padding)
            .background(.thickMaterial)
            .cornerRadius(sectionStyle.cornerRadius)
            .padding(.bottom, sectionStyle.verticalSpacing)
        }
        .buttonStyle(.plain)  // 保持文字样式不变
        .animation(
            .spring(response: 0.3, dampingFraction: 0.8), value: section.status)
    }

    /// 标题内容（包含标题文本和进度指示器）
    /// 包含在 sectionHeaderView 中
    private var headerContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            sectionTitle
            progressIndicator
        }
    }

    /// 区域标题文本
    /// 包含在 headerContent > sectionHeaderView 中
    private var sectionTitle: some View {
        HStack {
            Text(section.name)
                .font(sectionStyle.titleFont)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.vertical, 2)  // 增加点击区域
            Spacer()
        }

    }

    /// 横向进度指示器
    /// 包含在 contentAreaView 中
    private var progressIndicator: some View {
        HStack(spacing: 10) {
            Text(section.checkedVsTotal)
                .font(sectionStyle.subtitleFont)
                .foregroundColor(.secondary)
            progressBarView
        }
    }

    /// 横向进度条视图
    /// 包含在 progressIndicator > 中
    private var progressBarView: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.2))
                .frame(height: 4)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(section.statusColor)
                        .frame(
                            width: section.items.isEmpty
                                ? 0 : geometry.size.width * section.checkRatio,
                            height: 4
                        )
                        .animation(
                            .easeInOut(duration: 0.5),
                            value: section.checkedCount)
                }
        }
        .frame(height: 4)
    }

    /// 任务列表视图
    /// 包含在 contentAreaView 中
    private var itemsListView: some View {
        VStack(alignment: .leading, spacing: sectionStyle.verticalSpacing + 2) {
            ForEach($section.items) { $item in
                AChecklistItemView(item: $item)
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.8),
                        value: item)
            }
        }
        .padding(.bottom, 16)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
    @State var section = AChecklistSection(
        name: "任务",
        items: [
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

// MARK: - Extension for SectionStyle

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
extension AChecklistSectionView {
    private struct SectionStyle {
        let cornerRadius: CGFloat
        let padding: CGFloat
        let titleFont: Font
        let subtitleFont: Font
        let verticalSpacing: CGFloat
        let horizontalSpacing: CGFloat
        let sidebarWidth: CGFloat
    }

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
}
