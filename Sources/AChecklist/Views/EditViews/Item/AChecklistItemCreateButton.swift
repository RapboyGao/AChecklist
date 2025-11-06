import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistItemCreateButton: View {
  var onCreation: (AChecklistItem) -> Void

  @State private var item: AChecklistItem = .createRandom()
  @State private var isSheetPresented: Bool = false

  #if !os(watchOS)
    @ViewBuilder
    private var sheetContent: some View {
      CompatibilityNavigationViewWithToolbar {
        AChecklistItemEditContent($item)
      } toolbarContent: {
        Button {
          isSheetPresented = false
        } label: {
          Text(SwiftI18n.done.description)
        }
      }
    }
  #endif

  public var body: some View {
    #if os(watchOS)
      // watchOS 不支持创建按钮
      EmptyView()
    #elseif os(visionOS)
      SwiftI18n.add.buttonWithDefaultImage {
        isSheetPresented = true
      }
      .sheet(isPresented: $isSheetPresented) {
        sheetContent
      }
      .onChange(of: isSheetPresented) { newValue, _ in
        if !newValue {
          onCreation(item)
          item = .createRandom()
        }
      }
    #else
      SwiftI18n.add.buttonWithDefaultImage {
        isSheetPresented = true
      }
      .sheet(isPresented: $isSheetPresented) {
        sheetContent
      }
      .onChange(of: isSheetPresented) { newValue in
        if !newValue {
          onCreation(item)
          item = .createRandom()
        }
      }
    #endif
  }

  public init(onCreation: @escaping (AChecklistItem) -> Void) {
    self.onCreation = onCreation
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct Example: View {
  var body: some View {
    AChecklistItemCreateButton { item in
      print(item)
    }
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistItemCreateButton_Previews: PreviewProvider {
  static var previews: some View {
    Example()
  }
}
