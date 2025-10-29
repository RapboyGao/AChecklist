import SwiftRelativeTime
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistItemView: View {
    @Binding var item: AChecklistItem
    @State private var date = Date()

    public var body: some View {
        Button {
            item.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(.regularMaterial)
                HStack {
                    Text(item.title)
                    Spacer()
                    if let date = item.lastChecked {
                        Text(SwiftRelativeTime(date, now: .now).description)
                    }
                }
                .padding()
            }
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
#Preview {
    Example()
}
