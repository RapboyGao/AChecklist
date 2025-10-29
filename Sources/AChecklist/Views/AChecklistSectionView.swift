import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistSectionView: View {
    @Binding var section: AChecklistSection

    public var body: some View {
        LazyVStack(alignment: .leading) {
            Text(section.name)
                .font(.title)
                .padding(.bottom, 8)
            ForEach($section.items) { $item in
                AChecklistItemView(item: $item)
            }
        }
        .padding()
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
    @State var section = AChecklistSection(name: "任务", items: [
        AChecklistItem(title: " flashlight", detail: "充电后注意查看指示灯"),
        AChecklistItem(title: " 电池", detail: "充电后注意查看指示灯"),
        AChecklistItem(title: " 手电筒", detail: "充电后注意查看指示灯"),
    ])

    var body: some View {
        AChecklistSectionView(section: $section)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
#Preview {
    Example()
}
