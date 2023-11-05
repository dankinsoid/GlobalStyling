import SwiftUI

public struct StyleValues {

    let box: Box

    public subscript<T>(_ keyPath: KeyPath<StyleValues, T>) -> T? {
        get {
            box[keyPath]
        }
        set {
            box[keyPath] = newValue
        }
    }

    public subscript(scope keyPath: KeyPath<StyleValues, StyleValues>) -> StyleValues {
        get {
            StyleValues(box: box[scope: keyPath.appending(path: \.box)])
        }
        set {
            box[scope: keyPath.appending(path: \.box)] = newValue.box
        }
    }

    public subscript<T>(scope keyPath: KeyPath<StyleValues, Scope<T>>) -> Scope<T> {
        get {
            Scope<T>(box: box[scope: keyPath.appending(path: \.box)])
        }
        set {
            box[scope: keyPath.appending(path: \.box)] = newValue.box
        }
    }

    public subscript<T>(scope type: T.Type) -> StyleValues.Scope<T> {
        get {
            StyleValues.Scope<T>(box: box[scope: ObjectIdentifier(T.self)])
        }
        set {
            box[scope: ObjectIdentifier(T.self)] = newValue.box
        }
    }

    public mutating func scope<T>(_ type: T.Type, _ transform: (inout StyleValues.Scope<T>) -> Void) {
        transform(&self[scope: type])
    }

    public mutating func appearance<T: UIAppearance>(_ type: T.Type, _ transform: @escaping (T) -> Void) {
        scope(type) {
            $0.addAppearance(transform)
        }
    }

    public mutating func callAsFunction(_ transform: (inout Self) -> Void) {
        transform(&self)
    }

    @dynamicMemberLookup
    public struct Scope<T> {

        let box: Box

        public subscript<V>(_ keyPath: KeyPath<Scope<T>, V>) -> V? {
            get {
                box[keyPath]
            }
            set {
                box[keyPath] = newValue
            }
        }

        public subscript<V>(scope keyPath: KeyPath<Scope<T>, Scope<V>>) -> Scope<V> {
            get {
                Scope<V>(box: box[scope: keyPath.appending(path: \.box)])
            }
            set {
                box[scope: keyPath.appending(path: \.box)] = newValue.box
            }
        }

        public subscript(scope keyPath: KeyPath<Scope<T>, StyleValues>) -> StyleValues {
            get {
                StyleValues(box: box[scope: keyPath.appending(path: \.box)])
            }
            set {
                box[scope: keyPath.appending(path: \.box)] = newValue.box
            }
        }

        public subscript<V>(scope type: V.Type) -> StyleValues.Scope<V> {
            get {
                StyleValues.Scope<V>(box: box[scope: ObjectIdentifier(V.self)])
            }
            set {
                box[scope: ObjectIdentifier(V.self)] = newValue.box
            }
        }

        public subscript<V>(dynamicMember keyPath: KeyPath<StyleValues, V>) -> V {
            StyleValues(box: box)[keyPath: keyPath]
        }

        public subscript<V>(dynamicMember keyPath: WritableKeyPath<StyleValues, V>) -> V {
            get {
                StyleValues(box: box)[keyPath: keyPath]
            }
            set {
                var values = StyleValues(box: box)
                values[keyPath: keyPath] = newValue
            }
        }

        public mutating func scope<V>(_ type: V.Type, _ transform: (inout StyleValues.Scope<V>) -> Void) {
            transform(&self[scope: type])
        }

        public mutating func appearance<V: UIAppearance>(_ type: V.Type, _ transform: @escaping (V) -> Void) {
            scope(type) {
                $0.addAppearance(transform)
            }
        }

        public mutating func callAsFunction(_ transform: (inout Self) -> Void) {
            transform(&self)
        }
    }

    final class Box {

        private var values: [AnyKeyPath: Any] = [:]
        private var children: [AnyHashable: Box] = [:]
        private weak var parent: Box?

        static let root = Box()

        var child: Box {
            let box = Box()
            box.parent = self
            return box
        }
        
        func set(box: Box) {
            parent = box.parent
            values = box.values
            children = box.children
        }

        subscript<T>(_ keyPath: AnyKeyPath) -> T? {
            get {
                (values[keyPath] as? T) ?? parent?[keyPath]
            }
            set {
                values[keyPath] = newValue
            }
        }

        subscript(scope key: AnyHashable) -> Box {
            get {
                let result = children[key] ?? Box()
                children[key] = result
                result.parent = self
                return result
            }
            set {
                children[key] = newValue
                newValue.parent = self
            }
        }
    }
}

extension StyleValues {
    
    public static var global: StyleValues {
        get { StyleValues(box: .root) }
        set { Box.root.set(box: newValue.box) }
    }
}
