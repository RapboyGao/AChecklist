import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistItemView: View {
    @Binding var item: AChecklistItem
    @State private var currentDate = Date()
    @State private var isAnimating = false
    
    // 使用系统自带的相对时间格式化器
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
        return formatter
    }()
    
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // 降低刷新频率到每分钟

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
            currentDate = Date()
        } label: {
            HStack(alignment: .top, spacing: 16) {
                // 勾选框
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(item.lastChecked != nil ? .green : .secondary, lineWidth: 2)
                        .background(item.lastChecked != nil ? .green.opacity(0.1) : .clear)
                        .frame(width: 24, height: 24)
                    if item.lastChecked != nil {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .font(.system(size: 16, weight: .bold))
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                    }
                }
                .animation(.spring(response: 0.3), value: item.lastChecked)

                // 内容区域
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.title)
                            .font(.body)
                            .fontWeight(item.lastChecked != nil ? .medium : .regular)
                            .foregroundColor(item.lastChecked != nil ? .secondary : .primary)
                        Spacer()
                        if let date = item.lastChecked {
                            Text(relativeFormatter.localizedString(for: date, relativeTo: currentDate))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    if !item.detail.isEmpty {
                        Text(item.detail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .opacity(item.lastChecked != nil ? 0.7 : 1.0)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .scaleEffect(isAnimating ? 1.02 : 1.0)
            .animation(.spring(response: 0.3), value: isAnimating)
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(timer) { _ in
            currentDate = Date()
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
    @State var item = AChecklistItem(title: "手电筒充电", detail: "充电后注意查看指示灯")

    var body: some View {
        LazyVStack {
            AChecklistItemView(item: $item)
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
