import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistSectionEditView: View {
  @Binding var section: AChecklistSection

  public var body: some View {
    Section {
      HStack {
        Image(
          systemName: SwiftI18n.part
            .defaultSystemImage
        )
        .foregroundColor(.accentColor)
        TextField(
          SwiftI18n.name.description,
          text: $section.name
        )
        .multilineTextAlignment(.trailing)
      }
      Toggle(
        I18n.mutualExclusion,
        isOn: $section.isMutualExclusion)
      //        systemImage: "text.line.magnify"
      ForEach($section.items) { $item in
        AChecklistItemEditView(item: $item)
      }
      .onDelete(perform: deleteItems)
      .onMove(perform: moveItems)
    } footer: {
      Text(I18n.mutualExclusionExplanation)
    }
  }

  private func deleteItems(at offsets: IndexSet) {
    section.items.remove(atOffsets: offsets)
  }

  private func moveItems(from source: IndexSet, to destination: Int) {
    section.items.move(fromOffsets: source, toOffset: destination)
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct ExampleView: View {
  @State var section: AChecklistSection = AChecklist.example.sections[0]

  public var body: some View {
    AChecklistSectionEditView(section: $section)
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct AChecklistSectionEditView_Previews: PreviewProvider {
  static var previews: some View {
    List {
      ExampleView()
    }

  }
}
