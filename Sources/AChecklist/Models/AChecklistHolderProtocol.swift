import Combine
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol AChecklistHolderProtocol: NSObject, ObservableObject {
  var checklistData: Data? { get set }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension AChecklistHolderProtocol {
  public var checklist: AChecklist {
    get {
      return AChecklist(data: checklistData) ?? AChecklist()
    }
    set {
      checklistData = try? JSONEncoder().encode(newValue)
    }
  }
}
