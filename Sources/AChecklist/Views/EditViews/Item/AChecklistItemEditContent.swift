import SwiftI18n
import SwiftUI

#if !os(watchOS)

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
    public struct AChecklistItemEditContent: View {
        @Binding var item: AChecklistItem

        @ViewBuilder
        private var secondsHStack: some View {
            HStack {
                TextField(
                    I18n.seconds,
                    value: $item.expiresAfter.second,
                    format: .number
                )
                #if !os(macOS)
                    .keyboardType(.numberPad)
                #endif
                switch item.expiresAfter.second {
                case 0:
                    Text(I18n.second)
                default:
                    Text(I18n.seconds)
                }
            }
        }

        @ViewBuilder
        private var minutesHStack: some View {
            HStack {
                TextField(
                    I18n.minutes,
                    value: $item.expiresAfter.minute,
                    format: .number
                )
                #if !os(macOS)
                    .keyboardType(.numberPad)
                #endif
                switch item.expiresAfter.minute {
                case 0:
                    Text(I18n.minute)
                default:
                    Text(I18n.minutes)
                }
            }
        }

        @ViewBuilder
        private var hoursHStack: some View {
            HStack {
                TextField(
                    I18n.hours,
                    value: $item.expiresAfter.hour,
                    format: .number
                )
                #if !os(macOS)
                    .keyboardType(.numberPad)
                #endif
                switch item.expiresAfter.hour {
                case 0:
                    Text(I18n.hour)
                default:
                    Text(I18n.hours)
                }
            }
        }

        @ViewBuilder
        private var daysHStack: some View {
            HStack {
                TextField(
                    I18n.days,
                    value: $item.expiresAfter.day,
                    format: .number
                )
                #if !os(macOS)
                    .keyboardType(.numberPad)
                #endif
                switch item.expiresAfter.day {
                case 0:
                    Text(I18n.day)
                default:
                    Text(I18n.days)
                }
            }
        }

        @ViewBuilder
        private var monthHStack: some View {
            HStack {
                TextField(
                    I18n.months,
                    value: $item.expiresAfter.month,
                    format: .number
                )
                #if !os(macOS)
                    .keyboardType(.numberPad)
                #endif
                switch item.expiresAfter.month {
                case 0:
                    Text(I18n.month)
                default:
                    Text(I18n.months)
                }
            }
        }

        @ViewBuilder
        private var yearHStack: some View {
            HStack {
                TextField(
                    I18n.years,
                    value: $item.expiresAfter.year,
                    format: .number
                )
                #if !os(macOS)
                    .keyboardType(.numberPad)
                #endif
                switch item.expiresAfter.year {
                case 0:
                    Text(I18n.year)
                default:
                    Text(I18n.years)
                }
            }
        }

        public var body: some View {
            List {
                Section(I18n.checklistItem) {
                    // 最多25个字符
                    TextField(
                        SwiftI18n.title.description,
                        text: $item.title
                    )
                    .padding(.vertical)
                    .onChange(of: item.title) { newValue in
                        if newValue.count > 25 {
                            item.title = String(newValue.prefix(25))
                        }
                    }
                    // 最多200个字符
                    TextEditor(text: $item.detail)
                        .frame(minHeight: 100)
                        .onChange(of: item.detail) { newValue in
                            if newValue.count > 200 {
                                item.detail = String(newValue.prefix(200))
                            }
                        }
                }

                Section(I18n.expiresAfter) {
                    secondsHStack
                    minutesHStack
                    hoursHStack
                    daysHStack
                    monthHStack
                    yearHStack
                }

            }
            .navigationTitle(item.title)

        }

        public init(_ item: Binding<AChecklistItem>) {
            self._item = item
        }
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
    private struct Example: View {
        @State var item: AChecklistItem = AChecklistItem(
            title: "Example",
            detail: "Example Detail"
        )

        var body: some View {
            AChecklistItemEditContent($item)
        }
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    struct AChecklistItemEditContent_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                Example()

            }

        }
    }
#endif
