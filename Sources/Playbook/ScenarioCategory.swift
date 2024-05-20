/// Represents a unique identifier of the set of scenarios.
public struct ScenarioCategory: Hashable, RawRepresentable, ExpressibleByStringLiteral, CustomStringConvertible, ExpressibleByStringInterpolation {
    /// The raw string value.
    public var rawValue: String

    /// A textual representation of this instance.
    public var description: String { rawValue }

    /// Creates a new category with given raw string value.
    ///
    /// - Parameters:
    ///   - rawValue: The raw string value.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a new category with given raw string value.
    ///
    /// - Parameters:
    ///   - value: The raw string value.
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
