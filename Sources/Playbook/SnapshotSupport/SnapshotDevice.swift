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

    /// `iPhone SE` simulated device.
    ///
    /// - Parameters:
    ///   - orientation: A simulated orientation.
    ///   - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone SE`.
    @available(iOS 12.0, *)
    public static func iPhoneSE(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhoneSE(orientation).style(style)
    }

    /// `iPhone SE` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone SE`.
    public static func iPhoneSE(_ orientation: Orientation) -> SnapshotDevice {
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

    /// `iPhone 8` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone 8`.
    @available(iOS 12.0, *)
    public static func iPhone8(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhone8(orientation).style(style)
    }

    /// `iPhone 8` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 8`.
    public static func iPhone8(_ orientation: Orientation) -> SnapshotDevice {
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
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone 8 Plus`.
    @available(iOS 12.0, *)
    public static func iPhone8Plus(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhone8Plus(orientation).style(style)
    }

    /// `iPhone 8 Plus` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 8 Plus`.
    public static func iPhone8Plus(_ orientation: Orientation) -> SnapshotDevice {
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

    /// `iPhone X` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone X`.
    @available(iOS 12.0, *)
    public static func iPhoneX(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhoneX(orientation).style(style)
    }

    /// `iPhone X` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone X`.
    public static func iPhoneX(_ orientation: Orientation) -> SnapshotDevice {
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
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone XS`.
    @available(iOS 12.0, *)
    public static func iPhoneXS(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhoneXS(orientation).style(style)
    }

    /// `iPhone XS` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone XS`.
    public static func iPhoneXS(_ orientation: Orientation) -> SnapshotDevice {
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
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone XR`.
    @available(iOS 12.0, *)
    public static func iPhoneXR(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhoneXR(orientation).style(style)
    }

    /// `iPhone XR` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone XR`.
    public static func iPhoneXR(_ orientation: Orientation) -> SnapshotDevice {
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
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone XS Max`.
    @available(iOS 12.0, *)
    public static func iPhoneXSMax(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhoneXSMax(orientation).style(style)
    }

    /// `iPhone XS Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone XS Max`.
    public static func iPhoneXSMax(_ orientation: Orientation) -> SnapshotDevice {
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

    /// `iPhone 11` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone 11`.
    @available(iOS 12.0, *)
    public static func iPhone11(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhone11(orientation).style(style)
    }

    /// `iPhone 11` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 11`.
    public static func iPhone11(_ orientation: Orientation) -> SnapshotDevice {
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
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone 11 Pro`.
    @available(iOS 12.0, *)
    public static func iPhone11Pro(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhone11Pro(orientation).style(style)
    }

    /// `iPhone 11 Pro` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 11 Pro`.
    public static func iPhone11Pro(_ orientation: Orientation) -> SnapshotDevice {
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
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPhone 11 Pro Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPhone 11 Pro Max`.
    @available(iOS 12.0, *)
    public static func iPhone11ProMax(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPhone11ProMax(orientation).style(style)
    }

    /// `iPhone 11 Pro Max` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPhone 11 Pro Max`.
    public static func iPhone11ProMax(_ orientation: Orientation) -> SnapshotDevice {
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
                forceTouchCapability: .available,
                preferredContentSizeCategory: .medium
            )
        )
    }

    /// `iPad Mini 5th generation` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPad Mini 5th generation`.
    @available(iOS 12.0, *)
    public static func iPadMini5th(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPadMini5th(orientation).style(style)
    }

    /// `iPad Mini 5th generation` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Mini 5th generation`.
    public static func iPadMini5th(_ orientation: Orientation) -> SnapshotDevice {
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

    /// `iPad Pro 10.5 inch` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPad Pro 10.5 inch`.
    @available(iOS 12.0, *)
    public static func iPadPro10_5(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPadPro10_5(orientation).style(style)
    }

    /// `iPad Pro 10.5 inch` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Pro 10.5 inch`.
    public static func iPadPro10_5(_ orientation: Orientation) -> SnapshotDevice {
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
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPad Pro 11`.
    @available(iOS 12.0, *)
    public static func iPadPro11(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPadPro11(orientation).style(style)
    }

    /// `iPad Pro 11` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Pro 11`.
    public static func iPadPro11(_ orientation: Orientation) -> SnapshotDevice {
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
    ///    - style: A theme of UI appearance.
    ///
    /// - Returns: A device simulated the `iPad Pro 12.9 inch`.
    @available(iOS 12.0, *)
    public static func iPadPro12_9(_ orientation: Orientation, style: UIUserInterfaceStyle) -> SnapshotDevice {
        iPadPro12_9(orientation).style(style)
    }

    /// `iPad Pro 12.9 inch` simulated device.
    ///
    /// - Parameters:
    ///    - orientation: A simulated orientation.
    ///
    /// - Returns: A device simulated the `iPad Pro 12.9 inch`.
    public static func iPadPro12_9(_ orientation: Orientation) -> SnapshotDevice {
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

private extension SnapshotDevice {
    @available(iOS 12.0, *)
    func style(_ style: UIUserInterfaceStyle) -> SnapshotDevice {
        addingTraitCollection(UITraitCollection(userInterfaceStyle: style))
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
