@propertyWrapper
internal final class WeakReference<Value: AnyObject> {
    var wrappedValue: Value? {
        get { value }
        set { value = newValue }
    }

    private weak var value: Value?

    init(wrappedValue: Value?) {
        value = wrappedValue
    }
}
