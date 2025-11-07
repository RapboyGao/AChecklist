import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistEditView: View {
  @Binding var checklist: AChecklist

  public var body: some View {
    ScrollViewReader { proxy in
      List {
        Section {
          TextField(SwiftI18n.name.description, text: $checklist.name)
        }
        ForEach($checklist.sections) { $section in
          AChecklistSectionEditView(section: $section) { id in
            checklist.removeSection(id: id)
          }
          .id(section.id)
        }
        Section {
          SwiftI18n.create.buttonWithDefaultImage {
            checklist.sections.append(.createRandom())
            // 等渲染完成后
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              withAnimation {
                proxy.scrollTo("addSectionButton")
              }
            }
          }
        }
        .id("addSectionButton")
      }
    }
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct ExampleView: View {
  @State var checklist: AChecklist = AChecklist.example

  public var body: some View {
    CompatibilityNavigationViewWithToolbar {
      AChecklistEditView(checklist: $checklist)
    } toolbarContent: {
      #if !os(watchOS)
        EditButton()
      #endif
    }
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistEditView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleView()
  }
}
