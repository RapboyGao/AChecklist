import SwiftI18n
import SwiftUI

#if !os(watchOS)

  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
  public struct AChecklistItemEditContent: View {
    @Binding var item: AChecklistItem

    public var body: some View {
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

    }

    public init(_ item: Binding<AChecklistItem>) {
      self._item = item
    }
  }

#endif
