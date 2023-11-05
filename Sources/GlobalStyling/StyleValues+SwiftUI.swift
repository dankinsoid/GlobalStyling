import SwiftUI

private enum StyleValuesKey: EnvironmentKey {
    
    static var defaultValue: StyleValues.Box {
        .root
    }
}

private extension EnvironmentValues {
    
    var styleBox: StyleValues.Box {
        get {
            self[StyleValuesKey.self]
        }
        set {
            self[StyleValuesKey.self] = newValue
        }
    }
}

public extension EnvironmentValues {
    
    var style: StyleValues {
        StyleValues(box: styleBox)
    }
}

public extension StyleValues {
    
    var foregroundColor: Color {
        get { self[\.foregroundColor] ?? Color(UIColor.label) }
        set { self[\.foregroundColor] = newValue }
    }
    
    var tintColor: Color? {
        get { self[\.tintColor] ?? nil }
        set { self[\.tintColor] = newValue }
    }
    
    var font: Font {
        get { self[\.font] ?? Font.system(.body) }
        set { self[\.font] = newValue }
    }
    
    var textAlignment: TextAlignment {
        get { self[\.textAlignment] ?? .leading }
        set { self[\.textAlignment] = newValue }
    }
    
    var backgroundColor: Color {
        get { self[\.backgroundColor] ?? Color(UIColor.systemBackground) }
        set { self[\.backgroundColor] = newValue }
    }
}

extension View {
    
    public func transformStyle(_ transform: @escaping (inout StyleValues) -> Void) -> some View {
        modifier(StyleWrapper())
            .transformEnvironment(\.styleBox) { box in
                var result = StyleValues(box: box.child)
                transform(&result)
                box = result.box
            }
    }
    
    public func transformStyle(_ keyPath: WritableKeyPath<StyleValues, StyleValues>, _ transform: @escaping (inout StyleValues) -> Void) -> some View {
        transformStyle {
            transform(&$0[keyPath: keyPath])
        }
    }
    
    public func transformStyle<T>(_ keyPath: WritableKeyPath<StyleValues, StyleValues.Scope<T>>, _ transform: @escaping (inout StyleValues.Scope<T>) -> Void) -> some View {
        transformStyle {
            transform(&$0[keyPath: keyPath])
        }
    }
    
    public func transformStyle<T>(_ type: T.Type, _ transform: @escaping (inout StyleValues.Scope<T>) -> Void) -> some View {
        transformStyle {
            transform(&$0[scope: type])
        }
    }
    
    public func transformStyle<T>(_ keyPath: WritableKeyPath<StyleValues, T>, _ value: T) -> some View {
        transformStyle {
            $0[keyPath: keyPath] = value
        }
    }
    
    public func style(_ style: StyleValues) -> some View {
        modifier(StyleWrapper())
            .environment(\.styleBox, style.box)
    }
    
    public func style<V>(_ style: StyleValues.Scope<V>) -> some View {
        modifier(StyleWrapper())
            .environment(\.styleBox, style.box)
    }
    
    public func style(_ keyPath: KeyPath<StyleValues, StyleValues>) -> some View {
        modifier(StyleWrapper())
            .transformEnvironment(\.styleBox) { box in
                box = StyleValues(box: box)[keyPath: keyPath].box
            }
    }
    
    public func style<T>(_ keyPath: KeyPath<StyleValues, StyleValues.Scope<T>>) -> some View {
        modifier(StyleWrapper())
            .transformEnvironment(\.styleBox) { box in
                box = StyleValues(box: box)[keyPath: keyPath].box
            }
    }
    
    public func style<T>(_ type: T.Type) -> some View {
        modifier(StyleWrapper())
            .transformEnvironment(\.styleBox) { box in
                box = box[scope: ObjectIdentifier(type)]
            }
    }
}

private struct StyleWrapper: ViewModifier {
    
    @Environment(\.style) var style
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            bodyIOS13(content: content)
                .tint(style.tintColor)
        } else {
            bodyIOS13(content: content)
        }
    }
    
    func bodyIOS13(content: Content) -> some View {
        content
            .foregroundColor(style.foregroundColor)
            .font(style.font)
            .multilineTextAlignment(style.textAlignment)
    }
}

@propertyWrapper
public struct Styles<Value>: DynamicProperty {
    
    @Environment(\.style) private var style
    private let getter: (StyleValues) -> Value
    
    public var wrappedValue: Value {
        getter(style)
    }
}

extension Styles {
    
    public init(_ keyPath: KeyPath<StyleValues, Value>) {
        self.init {
            $0[keyPath: keyPath]
        }
    }
    
    public init<T>(_ type: T.Type) where Value == StyleValues.Scope<T> {
        self.init {
            $0[scope: type]
        }
    }
}

extension Styles<StyleValues> {
    
    public init() {
        self.init(\.self)
    }
}

struct TestView {

}

public enum H1 {}

extension StyleValues {

    public var body: StyleValues {
        get { self[scope: \.body] }
        set { self[scope: \.body] = newValue }
    }

    public var h1: StyleValues.Scope<H1> {
        self[scope: H1.self]
    }

    public var highlight: StyleValues {
        get { self[scope: \.highlight] }
        set { self[scope: \.highlight] = newValue }
    }
}

extension StyleValues.Scope<H1> {

    var someView: StyleValues.Scope<TestView> {
        self[scope: TestView.self]
    }
}

extension StyleValues {

//    mutating func configure() {
//        foregroundColor = .black
//        backgroundColor = .clear
//
//        body {
//            font = .system(.body)
//            foregroundColor = .gray
//            backgroundColor = .white
//        }
//
//        scope(H1.self) {
//            font = .system(.caption)
//            foregroundColor = .white
//            multilineAlignment = .center
//
//            scope(TestView.self) {
//                multilineAlignment = .leading
//            }
//        }
//
//        highlight {
//            backgroundColor = .yellow
//        }
//    }
}

func example() {
    StyleValues.global {
        $0.foregroundColor = .black
        $0.backgroundColor = .clear

        $0.body {
            $0.font = .system(.body)
            $0.foregroundColor = .gray
            $0.backgroundColor = .white
        }

        $0.scope(H1.self) {
            $0.font = .system(.caption)
            $0.foregroundColor = .white
            $0.textAlignment = .center

            $0.scope(TestView.self) {
                $0.textAlignment = .leading
            }
        }
        
        $0.appearance(UILabel.self) {
            $0.textColor = .red
        }

        $0.highlight {
            $0.backgroundColor = .yellow
        }
    }
}
