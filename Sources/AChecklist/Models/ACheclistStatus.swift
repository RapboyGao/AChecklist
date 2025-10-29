public enum AChecklistStatus:  Codable, Sendable, Hashable {
    case checked 
    case partiallyChecked
    case unchecked

    public var systemImageName: String {
        switch self {
        case .checked:
            return "checkmark.square.fill"
        case .partiallyChecked:
            return "minus.square"
        case .unchecked:
            return "square"
        }
    }
}