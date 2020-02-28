import UIKit

/// A namespace for the methods supporting to generate snapshot from scenarios.
public enum SnapshotSupport {
    /// The image format of the exported file.
    public enum ImageFormat {
        /// The PNG image file format.
        case png

        /// The JPEG image file format with given compression quality.
        case jpeg(quality: CGFloat)

        /// A file extension string for the image file exported by this image format.
        public var fileExtension: String {
            switch self {
            case .png:
                return "png"

            case .jpeg:
                return "jpg"
            }
        }
    }

    /// Generates an image file data that snapshots the given scenario.
    ///
    /// - Parameters:
    ///   - scenario: A scenario to be snapshot.
    ///   - device: A snapshot environment simulating device.
    ///   - format: An image file format of exported data.
    ///   - scale: A rendering scale of the snapshot image.
    ///   - keyWindow: The key window of the application.
    ///   - handler: A closure that to handle generated data.
    ///
    /// - Note: Passing the key window adds the scenario content to the view
    ///         hierarchy and actually renders it, so producing a more accurate
    ///         snapshot image.
    public static func data(
        for scenario: Scenario,
        on device: SnapshotDevice,
        format: ImageFormat,
        scale: CGFloat = UIScreen.main.scale,
        keyWindow: UIWindow? = nil,
        handler: @escaping (Data) -> Void
    ) {
        makeResource(for: scenario, on: device, scale: scale, keyWindow: keyWindow) { resource in
            withoutAnimation {
                handler(resource.renderer.data(format: format, actions: resource.actions))
            }
        }
    }

    /// Generates an `UIImage` that snapshots the given scenario.
    ///
    /// - Parameters:
    ///   - scenario: A scenario to be snapshot.
    ///   - device: A snapshot environment simulating device.
    ///   - scale: A rendering scale of the snapshot image.
    ///   - keyWindow: The key window of the application.
    ///   - handler: A closure that to handle generated `UIImage`.
    ///
    /// - Note: Passing the key window adds the scenario content to the view
    ///         hierarchy and actually renders it, so producing a more accurate
    ///         snapshot image.
    public static func image(
        for scenario: Scenario,
        on device: SnapshotDevice,
        scale: CGFloat = UIScreen.main.scale,
        keyWindow: UIWindow? = nil,
        handler: @escaping (UIImage) -> Void
    ) {
        makeResource(for: scenario, on: device, scale: scale, keyWindow: keyWindow) { resource in
            withoutAnimation {
                handler(resource.renderer.image(actions: resource.actions))
            }
        }
    }
}

private extension SnapshotSupport {
    struct Resource {
        var renderer: UIGraphicsImageRenderer
        var actions: UIGraphicsDrawingActions
    }

    static func makeResource(
        for scenario: Scenario,
        on device: SnapshotDevice,
        scale: CGFloat,
        keyWindow: UIWindow?,
        completion: @escaping (Resource) -> Void
    ) {
        let window = SnapshotWindow(scenario: scenario, device: device)
        let contentView = window.contentView!

        let isEmbedInKeyWindow: Bool

        if let keyWindow = keyWindow {
            keyWindow.addSubview(window)
            isEmbedInKeyWindow = true
        }
        else {
            isEmbedInKeyWindow = false
        }

        window.prepareForSnapshot {
            if contentView.bounds.size.width <= 0 {
                fatalError("The view did laid out with zero width in scenario - \(scenario.name)", file: scenario.file, line: scenario.line)
            }

            if contentView.bounds.size.height <= 0 {
                fatalError("The view did laied out with zero height in scenario - \(scenario.name)", file: scenario.file, line: scenario.line)
            }

            let format = UIGraphicsImageRendererFormat(for: device.traitCollection)
            format.scale = scale

            if #available(iOS 12.0, *) {
                format.preferredRange = .standard
            }
            else {
                format.prefersExtendedRange = false
            }

            let renderer = UIGraphicsImageRenderer(bounds: contentView.bounds, format: format)
            let actions: UIGraphicsDrawingActions = { context in
                if isEmbedInKeyWindow {
                    contentView.drawHierarchy(in: contentView.bounds, afterScreenUpdates: true)
                    contentView.removeFromSuperview()
                }
                else {
                    contentView.layer.render(in: context.cgContext)
                }
            }

            let resource = Resource(renderer: renderer, actions: actions)
            completion(resource)
        }
    }

    static func withoutAnimation<T>(_ action: () throws -> T) rethrows -> T {
        let disableActions = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        defer { CATransaction.setDisableActions(disableActions) }

        return try action()
    }
}

private extension UIGraphicsImageRenderer {
    func data(format: SnapshotSupport.ImageFormat, actions: (UIGraphicsImageRendererContext) -> Void) -> Data {
        switch format {
        case .png:
            return pngData(actions: actions)

        case .jpeg(let quality):
            return jpegData(withCompressionQuality: quality, actions: actions)
        }
    }
}
