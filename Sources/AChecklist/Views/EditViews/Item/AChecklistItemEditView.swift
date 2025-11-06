import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistItemEditView: View {
  @Binding var item: AChecklistItem
  @State private var isShown = false
  #if !os(watchOS)
    @ViewBuilder
    var sheetContent: some View {
      CompatibilityNavigationViewWithToolbar {
        AChecklistItemEditContent($item)
      } toolbarContent: {
        Button(SwiftI18n.done.description) {
          isShown.toggle()
        }
      }
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
        sheetContent
      }
    #endif

  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
  @State var item = AChecklistItem(title: "任务", detail: "充电后注意查看指示灯")
  var body: some View {
    NavigationView {
      List {
        AChecklistItemEditView(item: $item)
      }
    }
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistItemEditView_Previews: PreviewProvider {
  static var previews: some View {
    Example()
  }
}
