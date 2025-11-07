import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistHolderLegacyView<ChecklistHolder: AChecklistHolderProtocol>: View {
  @ObservedObject var holder: ChecklistHolder
  var showEdit: Bool
  @State private var checklist: AChecklist

  public var editButtonOverlay: some View {
    HStack {
      Spacer()
      VStack {
        Spacer()
        NavigationLink {
          AChecklistEditView(checklist: $checklist)
            .navigationTitle(checklist.name)
        } label: {
          Image(systemName: "pencil")
            .font(.system(size: 23))
            .background {
              Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 40, height: 40)
                .shadow(radius: 2)
            }
        }
      }
    }
    .padding(.bottom, 30)
    .padding(.trailing, 30)
  }

  public var body: some View {
    Group {
      if showEdit {
        ZStack {
          AChecklistUserView($checklist)
          editButtonOverlay
        }
      }
      else {
        AChecklistUserView($checklist)
      }
    }
  }

  public init(holder: ChecklistHolder, showEdit: Bool = false) {
    self.holder = holder
    self.showEdit = showEdit
    self._checklist = State(initialValue: holder.checklist)
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private class ChecklistHolderViewState: NSObject, AChecklistHolderProtocol {
  @Published var checklistData: Data?
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
private struct ExampleChecklistHolderView: View {
  @StateObject var holder = {
    let result = ChecklistHolderViewState()
    result.checklist = .example
    return result
  }()

  var body: some View {
    NavigationView {
      AChecklistHolderLegacyView(holder: holder, showEdit: true)
    }
    NavigationView {
      AChecklistHolderLegacyView(holder: holder, showEdit: false)
    }

  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct ExampleChecklistHolderView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleChecklistHolderView()
  }
}
