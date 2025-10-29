import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistView: View {
    @Binding var checklist: AChecklist

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach($checklist.sections) { $section in
                    AChecklistSectionView(section: $section)
                }
            }
        }
        .navigationTitle(checklist.name)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
    @State var checklist = AChecklist(name: "检查单1", sections: [
        AChecklistSection(name: "任务", items: [
            AChecklistItem(title: " flashlight", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: " 电池", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: " 手电筒", detail: "充电后注意查看指示灯"),
        ]),
        AChecklistSection(name: "其他", items: [
            AChecklistItem(title: " 充电器", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: " 电池", detail: "充电后注意查看指示灯"),
            AChecklistItem(title: " 手电筒", detail: "充电后注意查看指示灯"),
        ]),
    ])

    var body: some View {
        AChecklistView(checklist: $checklist)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
#Preview {
    NavigationView {
        Example()
    }
}
