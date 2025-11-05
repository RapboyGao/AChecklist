import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistSectionEditView: View {
  @Binding var section: AChecklistSection
  var onDelete: (UUID) -> Void

  @State private var isDeleteConfirmPresented = false
  @State private var showMutualExclusionExplanation = false
  @State private var mutualExclusionChecklist = AChecklist.mutualExclusionExplanation

  @ViewBuilder
  private var mutualExclusion: some View {
    #if os(watchOS)
      Toggle(
        I18n.mutualExclusion,
        isOn: $section.isMutualExclusion
      )
    #else
      HStack {
        Label(
          I18n.mutualExclusion,
          systemImage: "questionmark.circle"
        )
        .onTapGesture {
          showMutualExclusionExplanation = true
        }
        .sheet(
          isPresented: $showMutualExclusionExplanation,
          onDismiss: {
            showMutualExclusionExplanation = false
          }
        ) {
          CompatibilityNavigationView {
            AChecklistUserView($mutualExclusionChecklist)
              .toolbar {
                ToolbarItem {
                  SwiftI18n.close.button {
                    showMutualExclusionExplanation = false
                  }
                }

              }
          }
        }

        Spacer()
        Toggle(
          I18n.mutualExclusion,
          isOn: $section.isMutualExclusion
        )
        .labelsHidden()
      }
    #endif
  }

  @ViewBuilder
  private var titleEditor: some View {
    #if os(watchOS)
      TextField(
        SwiftI18n.name.description,
        text: $section.name
      )
      .font(.title2)
    #else
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

    #endif

  }

  public var body: some View {
    Section {
      titleEditor
      mutualExclusion
      ForEach($section.items) { $item in
        AChecklistItemEditView(item: $item)
      }
      .onDelete(perform: deleteItems)
      .onMove(perform: moveItems)
      AChecklistItemCreateButton { newItem in
        section.items.append(newItem)
      }
      Button(role: .destructive) {
        isDeleteConfirmPresented = true
      } label: {
        Label(
          SwiftI18n.delete.description,
          systemImage: SwiftI18n.delete.defaultSystemImage
        )
        .foregroundColor(.red)
      }
      .confirmationDialog(
        SwiftI18n.confirm.description,
        isPresented: $isDeleteConfirmPresented,
        titleVisibility: .visible
      ) {
        Button(SwiftI18n.delete.description, role: .destructive) {
          onDelete(section.id)
        }
        Button(SwiftI18n.cancel.description, role: .cancel) {
          isDeleteConfirmPresented = false
        }
      } message: {
        Text(I18n.confirmDeleteSection)
      }
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
    AChecklistSectionEditView(section: $section) { id in
      ()
    }
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
