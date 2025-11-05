import SwiftRelativeTime
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistCardView: View {
  // 绑定的检查单数据
  let checklist: AChecklist

  // 状态动画
  @State private var animatedProgress: Double = 0
  @State private var isHovered: Bool = false
  @State private var currentDate = Date(timeIntervalSinceNow: 1)

  private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

  // 计算统计信息
  private var totalItems: Int {
    checklist.sections.reduce(0) { $0 + $1.items.count }
  }

  private var checkedItems: Int {
    checklist.sections.reduce(0) { $0 + $1.checkedCount }
  }

  private var progress: Double {
    guard totalItems > 0 else { return 0 }
    return Double(checkedItems) / Double(totalItems)
  }

  private var hasExpiredItems: Bool {
    checklist.numberOfExpiredItems() > 0
  }

  public var body: some View {
    // 卡片容器
    ZStack {
      #if os(iOS)
        // iOS使用系统材料背景
        if #available(iOS 15.0, *) {
          Rectangle()
            .fill(.thickMaterial)
            .cornerRadius(cardStyle.cornerRadius)
            .shadow(radius: 10, x: 0, y: 5)
        }
        else {
          Rectangle()
            .fill(Color(.systemGroupedBackground))
            .cornerRadius(cardStyle.cornerRadius)
            .shadow(radius: 10, x: 0, y: 5)
        }
      #elseif os(macOS)
        // macOS使用窗口背景色
        if #available(macOS 12.0, *) {
          Rectangle()
            .fill(.thickMaterial)
            .cornerRadius(cardStyle.cornerRadius)
            .shadow(radius: 5, x: 0, y: 3)
        }
        else {
          Rectangle()
            .fill(Color(.windowBackgroundColor))
            .cornerRadius(cardStyle.cornerRadius)
            .shadow(radius: 5, x: 0, y: 3)
        }
      #else
        // 其他平台使用半透明背景
        Rectangle()
          .fill(Color.gray.opacity(0.1))
          .cornerRadius(cardStyle.cornerRadius)
          .shadow(radius: 5, x: 0, y: 3)
      #endif

      // 卡片内容
      VStack(alignment: .leading, spacing: cardStyle.padding / 2) {
        // 标题和状态
        HStack(alignment: .center) {
          Text(checklist.name)
            .font(cardStyle.titleFont)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .lineLimit(1)
        }

        // 统计信息
        HStack(alignment: .center, spacing: cardStyle.padding) {
          // 项目数量统计
          StatItem(
            icon: "checkmark.circle",
            text: "\(checkedItems)/\(totalItems)",
            size: cardStyle.iconSize
          )
        }

        Spacer()

        // 进度条
        VStack(alignment: .leading, spacing: 4) {
          Text("完成进度")
            .font(cardStyle.subtitleFont)
            .foregroundColor(.secondary)

          GeometryReader { geometry in
            ZStack(alignment: .leading) {
              // 背景条
              Rectangle()
                .fill(Color.secondary.opacity(0.2))
                .frame(height: cardStyle.progressHeight)
                .cornerRadius(cardStyle.progressHeight / 2)

              // 进度条
              Rectangle()
                .fill(checklist.statusColor)
                .frame(
                  width: geometry.size.width * animatedProgress,
                  height: cardStyle.progressHeight
                )
                .cornerRadius(cardStyle.progressHeight / 2)
                .animation(
                  .spring(response: 0.6, dampingFraction: 0.7)
                    .delay(0.3),
                  value: animatedProgress
                )
            }
          }
          .frame(height: cardStyle.progressHeight)
        }

        // 上次操作时间
        if let lastOpened = checklist.lastOpened {
          Text(SwiftRelativeTime(lastOpened, now: currentDate).description)
            .font(cardStyle.subtitleFont)
            .foregroundColor(.secondary)
        }
      }
      .padding(cardStyle.padding)
      .frame(minHeight: cardStyle.minHeight)
    }
    .frame(maxWidth: cardStyle.maxWidth)
    .padding(cardStyle.padding / 2)
    .onReceive(timer) { _ in
      currentDate = Date()
    }

    // 交互效果
    #if os(macOS)
      .onHover { hover in
        withAnimation {
          isHovered = hover
        }
      }
      .scaleEffect(isHovered ? 1.02 : 1.0)
      .animation(
        .spring(response: 0.3, dampingFraction: 0.7),
        value: isHovered
      )
    #endif

    // 视图出现时的动画
    .onAppear {
      withAnimation {
        animatedProgress = progress
      }
    }
    .onChange(of: checklist) { _ in
      currentDate = Date(timeIntervalSinceNow: 1)
    }

  }

  // 状态指示器组件
  private struct StatusIndicator: View {
    let status: AChecklistStatus
    let size: CGFloat

    var body: some View {
      switch status {
      case .checked:
        Image(systemName: "checkmark.circle.fill")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(.green)
      case .partiallyChecked:
        Image(systemName: "circle.fill")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(.orange)
      case .unchecked:
        Image(systemName: "circle")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(Color.secondary.opacity(0.5))
      }
    }
  }

  // 统计项组件
  private struct StatItem: View {
    let icon: String
    let text: String
    let size: CGFloat
    var isWarning: Bool { icon == "exclamationmark.triangle" }

    var body: some View {
      HStack(alignment: .center, spacing: 4) {
        Image(systemName: icon)
          .resizable()
          .frame(width: size * 0.7, height: size * 0.7)
          .foregroundColor(isWarning ? .orange : .secondary)

        Text(text)
          .font(.caption)
          .foregroundColor(isWarning ? .orange : .secondary)
      }

    }
  }

  public init(_ checklist: AChecklist) {
    self.checklist = checklist
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
extension AChecklistCardView {
  // 根据不同操作系统提供不同的卡片样式配置
  var cardStyle: CardStyle {
    #if os(iOS)
      return CardStyle(
        cornerRadius: 16,
        padding: 16,
        titleFont: .headline,
        subtitleFont: .subheadline,
        progressHeight: 8,
        iconSize: 24,
        maxWidth: .infinity,
        minHeight: 140
      )
    #elseif os(macOS)
      return CardStyle(
        cornerRadius: 12,
        padding: 20,
        titleFont: .system(size: 16, weight: .semibold),
        subtitleFont: .system(size: 13),
        progressHeight: 6,
        iconSize: 20,
        maxWidth: 400,
        minHeight: 120
      )
    #elseif os(tvOS)
      return CardStyle(
        cornerRadius: 20,
        padding: 24,
        titleFont: .system(size: 20, weight: .bold),
        subtitleFont: .system(size: 16),
        progressHeight: 10,
        iconSize: 28,
        maxWidth: 600,
        minHeight: 160
      )
    #elseif os(watchOS)
      return CardStyle(
        cornerRadius: 10,
        padding: 12,
        titleFont: .title3,
        subtitleFont: .caption,
        progressHeight: 5,
        iconSize: 18,
        maxWidth: .infinity,
        minHeight: 100
      )
    #else
      // 默认样式
      return CardStyle(
        cornerRadius: 14,
        padding: 16,
        titleFont: .headline,
        subtitleFont: .subheadline,
        progressHeight: 7,
        iconSize: 22,
        maxWidth: .infinity,
        minHeight: 130
      )
    #endif
  }

  struct CardStyle {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let titleFont: Font
    let subtitleFont: Font
    let progressHeight: CGFloat
    let iconSize: CGFloat
    let maxWidth: CGFloat
    let minHeight: CGFloat
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct AChecklistCardViewExample: View {
  @State var checklist: AChecklist = .example

  var body: some View {
    NavigationLink {
      AChecklistUserView($checklist)
    } label: {
      AChecklistCardView(checklist)
    }
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistCardView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          AChecklistCardViewExample()
          AChecklistCardViewExample()
          AChecklistCardViewExample()
          AChecklistCardViewExample()
          AChecklistCardViewExample()
          AChecklistCardViewExample()
        }
        .padding(.horizontal)
      }
    }
  }
}
