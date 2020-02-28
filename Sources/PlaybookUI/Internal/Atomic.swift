import Foundation

@propertyWrapper
internal final class Atomic<Value> {
    var wrappedValue: Value {
        get { modify { $0 } }
        set { modify { $0 = newValue } }
    }

    private let lock = NSLock()
    private var value: Value

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    @discardableResult
    func modify<T>(action: (inout Value) -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return action(&value)
    }

    @discardableResult
    func swap(_ newValue: Value) -> Value {
        modify { value in
            let oldValue = value
            value = newValue
            return oldValue
        }
    }
}
