import SwiftUI

/// 版本兼容的导航容器视图
/// 根据iOS/macOS版本自动选择合适的导航容器
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, *)
internal struct CompatibilityNavigationView<Content: View>: View {
    private let content: Content
    
    /// 初始化方法
    /// - Parameter content: 要在导航容器中显示的内容视图
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            // 在新版本中使用NavigationStack
            NavigationStack {
                content
            }
        } else {
            // 在旧版本中使用NavigationView
            NavigationView {
                content
                // 为iPad提供双列布局支持
                content
            }
        }
    }
}