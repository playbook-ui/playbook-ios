import UIKit

/// The device representation for simulating environments of each device such as
///  size, orientation, safe area, trait collection, or dark mode appearance.
public struct SnapshotDevice {
    /// Represents the orientation of a device.
    public enum Orientation {
        /// Device oriented vertically.
        case portrait

        /// Device oriented horizontally.
        case landscape
    }

    /// The name of this device that to be used as a directory name of snapshots.
    public var name: String

    /// The simulated size of this device.
    public var size: CGSize

    /// The simulated safe area insets of this device.
    public var safeAreaInsets: UIEdgeInsets

    /// The simulated trait collection of this device.
    public var traitCollection: UITraitCollection

    /// Creates a new custom device simulation.
    ///
    /// - Parameters:
    ///   - name: A name that to be used as a directory name of snapshots.
    ///   - size: A simulated device size.
    ///   - safeAreaInsets: A simulated safe area insets.
    ///   - traitCollection: A simulated trait collection.
    public init(
        name: String,
        size: CGSize,
        safeAreaInsets: UIEdgeInsets = .zero,
        traitCollection: UITraitCollection = UITraitCollection()
    ) {
        self.name = name
        self.size = size
        self.safeAreaInsets = safeAreaInsets
        self.traitCollection = traitCollection
    }

    /// Adds a user interface style as a trait collection.
    /// - Parameter style: A user interface style to be used.
    /// - Returns: The device that added the given user interface style
    ///            as a trait collection to `self`.
    @available(iOS 12.0, *)
    public func style(_ style: UIUserInterfaceStyle) -> SnapshotDevice {
        addingTraitCollection(UITraitCollection(userInterfaceStyle: style))
    }

    /// Adds an arbitrary trait collection to change the appearance.
    ///
    /// - Parameters
    ///   - traitCollection: A trait collection to be added.
    ///
    /// - Returns: The device that added the given trait collection to the `self`.
    public func addingTraitCollection(_ traitCollection: UITraitCollection) -> SnapshotDevice {
        let name: String

        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light:
                name = "\(self.name) (light)"

            case .dark:
                name = "\(self.name) (dark)"

            case .unspecified:
                name = self.name

            @unknown default:
                name = self.name
            }
        }
        else {
            name = self.name
        }

        return SnapshotDevice(
            name: name,
            size: size,
            safeAreaInsets: safeAreaInsets,
            traitCollection: UITraitCollection(traitsFrom: [self.traitCollection, traitCollection])
        )
    }
}

/// iPhone SE Series
public extension SnapshotDevice {
    /// `iPhone SE` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone SE`.
    static func iPhoneSE(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone SE \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 320, height: 568),
                landscape: CGSize(width: 568, height: 320)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                landscape: .zero
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 2,
                displayGamut: .SRGB,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPhone 8 Series
public extension SnapshotDevice {
    /// `iPhone 8` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 8`.
    static func iPhone8(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 8 \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 375, height: 667),
                landscape: CGSize(width: 667, height: 375)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                landscape: .zero
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 2,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 8 Plus` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 8 Plus`.
    static func iPhone8Plus(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 8 Plus \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 414, height: 736),
                landscape: CGSize(width: 736, height: 414)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                landscape: .zero
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPhone X Series
public extension SnapshotDevice {
    /// `iPhone X` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone X`.
    static func iPhoneX(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone X \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 375, height: 812),
                landscape: CGSize(width: 812, height: 375)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 44, bottom: 24, right: 44)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone XS` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone XS`.
    static func iPhoneXS(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone XS \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 375, height: 812),
                landscape: CGSize(width: 812, height: 375)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 44, bottom: 24, right: 44)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone XR` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone XR`.
    static func iPhoneXR(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone XR \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 414, height: 896),
                landscape: CGSize(width: 896, height: 414)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 44, bottom: 24, right: 44)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 2,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone XS Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone XS Max`.
    static func iPhoneXSMax(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone XS Max \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 414, height: 896),
                landscape: CGSize(width: 896, height: 414)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 44, bottom: 24, right: 44)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPhone 11 Series
public extension SnapshotDevice {
    /// `iPhone 11` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 11`.
    static func iPhone11(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 11 \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 414, height: 896),
                landscape: CGSize(width: 896, height: 414)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 44, bottom: 24, right: 44)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 2,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 11 Pro` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 11 Pro`.
    static func iPhone11Pro(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 11 Pro \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 375, height: 812),
                landscape: CGSize(width: 812, height: 375)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 44, bottom: 24, right: 44)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 11 Pro Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 11 Pro Max`.
    static func iPhone11ProMax(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 11 Pro Max \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 414, height: 896),
                landscape: CGSize(width: 896, height: 414)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 44, bottom: 24, right: 44)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPhone 12 Series
public extension SnapshotDevice {
    /// `iPhone 12 mini` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 12 mini`.
    static func iPhone12Mini(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 12 mini \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 360, height: 780),
                landscape: CGSize(width: 780, height: 360)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 50, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 50, bottom: 21, right: 50)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 12` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 12`.
    static func iPhone12(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 12 \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 390, height: 844),
                landscape: CGSize(width: 844, height: 390)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 12 Pro` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 12 Pro`.
    static func iPhone12Pro(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 12 Pro \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 390, height: 844),
                landscape: CGSize(width: 844, height: 390)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 12 Pro Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 12 Pro Max`.
    static func iPhone12ProMax(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 12 Pro Max \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 428, height: 926),
                landscape: CGSize(width: 926, height: 428)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPhone 13 Series
public extension SnapshotDevice {
    /// `iPhone 13 mini` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 13 mini`.
    static func iPhone13Mini(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 13 mini \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 375, height: 812),
                landscape: CGSize(width: 812, height: 375)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 50, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 50, bottom: 21, right: 50)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 13` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 13`.
    static func iPhone13(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 13 \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 390, height: 844),
                landscape: CGSize(width: 844, height: 390)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 13 Pro` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 13 Pro`.
    static func iPhone13Pro(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 13 Pro \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 390, height: 844),
                landscape: CGSize(width: 844, height: 390)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 13 Pro Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 13 Pro Max`.
    static func iPhone13ProMax(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 13 Pro Max \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 428, height: 926),
                landscape: CGSize(width: 926, height: 428)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPhone 14 Series
public extension SnapshotDevice {
    /// `iPhone 14 Pro` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 14 Pro`.
    static func iPhone14Pro(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 14 Pro \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 393, height: 852),
                landscape: CGSize(width: 852, height: 393)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 14 Pro Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 14 Pro Max`.
    static func iPhone14ProMax(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 14 Pro Max \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 430, height: 932),
                landscape: CGSize(width: 932, height: 430)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPhone 15 Series
public extension SnapshotDevice {
    /// `iPhone 15 Pro` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 15 Pro`.
    static func iPhone15Pro(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 15 Pro \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 393, height: 852),
                landscape: CGSize(width: 852, height: 393)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: .compact,
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 15 Pro Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 15 Pro Max`.
    static func iPhone15ProMax(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPhone 15 Pro Max \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 430, height: 932),
                landscape: CGSize(width: 932, height: 430)
            ),
            safeAreaInsets: orientation.use(
                portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
                landscape: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59)
            ),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .phone,
                displayScale: 3,
                displayGamut: .P3,
                horizontalSizeClass: orientation.use(portrait: .compact, landscape: .regular),
                verticalSizeClass: orientation.use(portrait: .regular, landscape: .compact),
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPad Mini
public extension SnapshotDevice {
    /// `iPad Mini 5th generation` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Mini 5th generation`.
    static func iPadMini5th(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPad mini 5th \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 768, height: 1024),
                landscape: CGSize(width: 1024, height: 768)
            ),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .pad,
                displayScale: 2,
                displayGamut: .SRGB,
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPad Mini 6th generation` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Mini 6th generation`.
    static func iPadMini6th(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPad mini 6th \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 744, height: 1133),
                landscape: CGSize(width: 1133, height: 744)
            ),
            safeAreaInsets: UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .pad,
                displayScale: 2,
                displayGamut: .SRGB,
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

/// iPad Pro
public extension SnapshotDevice {
    /// `iPad Pro 10.5 inch` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Pro 10.5 inch`.
    static func iPadPro10_5(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPad Pro 10_5 \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 834, height: 1112),
                landscape: CGSize(width: 1112, height: 834)
            ),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .pad,
                displayScale: 2,
                displayGamut: .P3,
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPad Pro 11` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Pro 11`.
    static func iPadPro11(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPad Pro 11 \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 834, height: 1194),
                landscape: CGSize(width: 1194, height: 834)
            ),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .pad,
                displayScale: 2,
                displayGamut: .P3,
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPad Pro 12.9 inch` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Pro 12.9 inch`.
    static func iPadPro12_9(_ orientation: Orientation) -> SnapshotDevice {
        SnapshotDevice(
            name: "iPad Pro 12_9 \(orientation.string)",
            size: orientation.use(
                portrait: CGSize(width: 1024, height: 1366),
                landscape: CGSize(width: 1366, height: 1024)
            ),
            safeAreaInsets: UIEdgeInsets(top: 24, left: 0, bottom: 20, right: 0),
            traitCollection: UITraitCollection(
                userInterfaceIdiom: .pad,
                displayScale: 2,
                displayGamut: .P3,
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                layoutDirection: .leftToRight,
                forceTouchCapability: .unavailable,
                preferredContentSizeCategory: .medium
            )
        )
    }
}

private extension UITraitCollection {
    convenience init(
        userInterfaceIdiom: UIUserInterfaceIdiom,
        displayScale: CGFloat,
        displayGamut: UIDisplayGamut,
        horizontalSizeClass: UIUserInterfaceSizeClass,
        verticalSizeClass: UIUserInterfaceSizeClass,
        layoutDirection: UITraitEnvironmentLayoutDirection,
        forceTouchCapability: UIForceTouchCapability,
        preferredContentSizeCategory: UIContentSizeCategory
    ) {
        self.init(traitsFrom: [
            UITraitCollection(displayScale: displayScale),
            UITraitCollection(displayGamut: displayGamut),
            UITraitCollection(userInterfaceIdiom: userInterfaceIdiom),
            UITraitCollection(horizontalSizeClass: horizontalSizeClass),
            UITraitCollection(verticalSizeClass: verticalSizeClass),
            UITraitCollection(layoutDirection: layoutDirection),
            UITraitCollection(forceTouchCapability: forceTouchCapability),
            UITraitCollection(preferredContentSizeCategory: preferredContentSizeCategory),
        ])
    }
}

private extension SnapshotDevice.Orientation {
    var string: String {
        switch self {
        case .portrait:
            return "portrait"

        case .landscape:
            return "landscape"
        }
    }

    func use<T>(portrait: @autoclosure () -> T, landscape: @autoclosure () -> T) -> T {
        switch self {
        case .portrait:
            return portrait()

        case .landscape:
            return landscape()
        }
    }
}
