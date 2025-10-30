import SwiftI18n
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
public struct AChecklistEditView: View {
    @Binding var checklist: AChecklist

    public var body: some View {
        List {
            ForEach($checklist.sections) { $section in
                AChecklistSectionEditView(section: $section)
            }
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct ExampleView: View {
    @State var checklist: AChecklist = AChecklist.example

    public var body: some View {
        AChecklistEditView(checklist: $checklist)
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct AChecklistEditView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
