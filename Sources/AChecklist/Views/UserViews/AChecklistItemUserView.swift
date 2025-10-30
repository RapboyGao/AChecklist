import SwiftRelativeTime
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistItemUserView: View {
  // 根据不同操作系统提供不同的样式配置
  private var itemStyle: ItemStyle {
    #if os(iOS)
      return ItemStyle(
        cornerRadius: 12,
        padding: 16,
        titleFont: .headline,
        detailFont: .subheadline,
        checkboxSize: 24
      )
    #elseif os(macOS)
      return ItemStyle(
        cornerRadius: 8,
        padding: 12,
        titleFont: .system(size: 14, weight: .medium),
        detailFont: .system(size: 12),
        checkboxSize: 20
      )
    #elseif os(tvOS)
      return ItemStyle(
        cornerRadius: 16,
        padding: 20,
        titleFont: .system(size: 20, weight: .medium),
        detailFont: .system(size: 16),
        checkboxSize: 32
      )
    #elseif os(watchOS)
      return ItemStyle(
        cornerRadius: 8,
        padding: 10,
        titleFont: .body,
        detailFont: .caption,
        checkboxSize: 18
      )
    #else
      // 默认样式
      return ItemStyle(
        cornerRadius: 10,
        padding: 14,
        titleFont: .headline,
        detailFont: .subheadline,
        checkboxSize: 22
      )
    #endif
  }

  private struct ItemStyle {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let titleFont: Font
    let detailFont: Font
    let checkboxSize: CGFloat
  }

  @Binding var item: AChecklistItem
  @State private var isAnimating = false

  // 使用系统自带的相对时间格式化器
  private let relativeFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    formatter.unitsStyle = .short
    return formatter
  }()

  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()  // 降低刷新频率到每分钟

  public var body: some View {
    Button {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
        item.toggle()
        isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation {
            isAnimating = false
          }
        }
      }
    } label: {
      HStack(alignment: .top, spacing: 16) {
        // 勾选框
        ZStack {
          RoundedRectangle(cornerRadius: itemStyle.checkboxSize / 3)
            .strokeBorder(item.lastChecked != nil ? .green : .secondary, lineWidth: 2)
            .background(item.lastChecked != nil ? .green.opacity(0.1) : .clear)
            .frame(width: itemStyle.checkboxSize, height: itemStyle.checkboxSize)
          if item.lastChecked != nil {
            Image(systemName: "checkmark")
              .resizable()
              .foregroundColor(.green)
              .frame(width: itemStyle.checkboxSize / 2, height: itemStyle.checkboxSize / 2)
              .scaleEffect(isAnimating ? 1.2 : 1.0)
          }
        }
        .animation(.spring(response: 0.3), value: item.lastChecked)

        // 内容区域
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            #if os(macOS)
              Text(item.title)
                .font(itemStyle.titleFont)
                .fontWeight(item.lastChecked != nil ? .medium : .regular)
                .foregroundColor(item.lastChecked != nil ? .secondary : .primary)
            #else
              Text(item.title)
                .font(itemStyle.titleFont)
                .fontWeight(item.lastChecked != nil ? .medium : .regular)
                .foregroundColor(item.lastChecked != nil ? .secondary : .primary)
            #endif
            Spacer()
            if let date = item.lastChecked {
              Text("\(SwiftRelativeTime(date, now: item.currentDate))")
                .font(.caption2)
                .foregroundColor(item.isExpired(now: item.currentDate) ? .red : .secondary)
            }
          }
          if !item.detailIsEmpty {
            #if os(macOS)
              Text(item.detail)
                .font(itemStyle.detailFont)
                .foregroundColor(item.lastChecked != nil ? .secondary : .primary)
                .lineLimit(2)
                .opacity(item.lastChecked != nil ? 0.7 : 1.0)
            #else
              Text(item.detail)
                .font(itemStyle.detailFont)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .opacity(item.lastChecked != nil ? 0.7 : 1.0)
            #endif
          }
        }
      }
      .padding(itemStyle.padding)
      .background(
        RoundedRectangle(cornerRadius: itemStyle.cornerRadius)
          .fill(.regularMaterial)
          .shadow(radius: 1)
      )
      #if os(macOS)
        .onHover { _ in
          // macOS hover效果
          withAnimation(.easeInOut(duration: 0.2)) {
            // 可以通过状态变量来控制hover效果
          }
        }
      #endif
      .scaleEffect(isAnimating ? 1.02 : 1.0)
      .animation(.spring(response: 0.3), value: isAnimating)
    }
    .buttonStyle(.plain)
    .onReceive(timer) { _ in
      item.currentDate = Date()
    }
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
  @State var item = AChecklistItem(title: "手电筒充电", detail: "充电后注意查看指示灯")

  var body: some View {
    LazyVStack {
      AChecklistItemUserView(item: $item)
    }
    .padding()
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistItemView_Previews: PreviewProvider {
  static var previews: some View {
    Example()
  }
}
