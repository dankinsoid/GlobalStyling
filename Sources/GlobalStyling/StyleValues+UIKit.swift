import UIKit

extension StyleValues.Scope where T: UIAppearance {

    var appearance: (T) -> Void {
        get { self[\.appearance] ?? { _ in } }
        set { self[\.appearance] = newValue }
    }

    mutating func addAppearance(_ transform: @escaping (T) -> Void) {
        let current = appearance
        appearance = {
            current($0)
            transform($0)
        }
    }

    public subscript<V>(dynamicMember keyPath: ReferenceWritableKeyPath<T, V>) -> V where T: UIAppearance {
        get {
            box[keyPath] ?? T.appearance()[keyPath: keyPath]
        }
        set {
            set(keyPath, newValue)
        }
    }

    public mutating func set<V>(_ keyPath: ReferenceWritableKeyPath<T, V>, _ value: V) {
        box[keyPath] = value
    }
}
