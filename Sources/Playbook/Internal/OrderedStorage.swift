internal struct OrderedStorage<Key: Hashable, Element>: RandomAccessCollection {
    private var keysAndElements = [Key: Element]()
    private var orderedKeys = ContiguousArray<Key>()

    mutating func append(_ element: Element, for key: Key) {
        if keysAndElements[key] == nil {
            orderedKeys.append(key)
        }

        keysAndElements[key] = element
    }

    mutating func element(for key: Key, default defaultElement: @autoclosure () -> Element) -> Element {
        if let element = keysAndElements[key] {
            return element
        }
        else {
            let element = defaultElement()
            orderedKeys.append(key)
            keysAndElements[key] = element
            return element
        }
    }
}

internal extension OrderedStorage {
    struct Iterator: IteratorProtocol {
        var keyIterator: ContiguousArray<Key>.Iterator
        var keysAndElements: [Key: Element]

        mutating func next() -> Element? {
            guard let key = keyIterator.next() else {
                return nil
            }

            return keysAndElements[key]
        }
    }

    var startIndex: Int {
        orderedKeys.startIndex
    }

    var endIndex: Int {
        orderedKeys.endIndex
    }

    subscript(index: Int) -> Element {
        let key = orderedKeys[index]
        return keysAndElements[key]!
    }

    func makeIterator() -> Iterator {
        Iterator(keyIterator: orderedKeys.makeIterator(), keysAndElements: keysAndElements)
    }
}
