import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistHolderView<ChecklistHolder: AChecklistHolderProtocol>: View {
  @ObservedObject var holder: ChecklistHolder
  var showEdit: Bool

  public var body: some View {
    AChecklistUserView($holder.checklist) {
      HStack {
        VStack {
          Text("edit")
        }
      }
    }
  }

  public init(holder: ChecklistHolder, showEdit: Bool = false) {
    self.holder = holder
    self.showEdit = showEdit
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
    AChecklistHolderView(holder: holder, showEdit: true)
  }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
struct ExampleChecklistHolderView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleChecklistHolderView()
  }
}
