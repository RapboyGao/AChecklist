import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistItemEditView: View {
    @Binding var item: AChecklistItem
    @State private var isShown = false

    #if !os(watchOS)
        private var listContent: some View {
            List {
                HStack {
                    Image(
                        systemName: SwiftI18n.name
                            .defaultSystemImage
                    )
                    .foregroundColor(.accentColor)
                    TextField(
                        SwiftI18n.title.description,
                        text: $item.title
                    )
                    .multilineTextAlignment(.trailing)
                }
                VStack(alignment: .leading) {
                    SwiftI18n.descriptionKey.text
                        .padding(.vertical)
                    TextEditor(text: $item.detail)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(item.title)
            #if !os(macOS)
                .toolbar {
                    ToolbarItemGroup {
                        Button(SwiftI18n.done.description) {
                            isShown.toggle()
                        }
                    }
                }
            #endif
        }
    #endif

    public var body: some View {
        #if os(watchOS)
            // 如果是watch 则只有一个简单的Textfield界面
            TextField(SwiftI18n.title.description, text: $item.title)

        #else
            Button {
                isShown.toggle()
            } label: {
                Label(
                    item.title, systemImage: SwiftI18n.edit.defaultSystemImage
                )
            }
            .sheet(isPresented: $isShown) {
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                    NavigationStack {
                        listContent
                    }

                } else {
                    NavigationView {
                        listContent
                        listContent
                    }
                }
            }
        #endif

    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct Example: View {
    @State var item = AChecklistItem(title: "任务", detail: "充电后注意查看指示灯")
    var body: some View {
        NavigationStack {
            List {
                AChecklistItemEditView(item: $item)
            }
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct AChecklistItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        Example()
    }
}
