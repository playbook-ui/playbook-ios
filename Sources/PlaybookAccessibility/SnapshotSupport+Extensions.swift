import UIKit
import Playbook
import AccessibilitySnapshot

extension SnapshotSupport {

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
    static func data(
        for scenario: Scenario,
        on device: SnapshotDevice,
        format: ImageFormat,
        scale: CGFloat = UIScreen.main.scale,
        keyWindow: UIWindow? = nil,
        handler: @escaping (Data) -> Void
    ) {
        makeResourceWithAccessibilityMarkers(
            for: scenario,
            on: device,
            scale: scale,
            keyWindow: keyWindow
        ) { resource in
            handler(resource.renderer.data(format: format, actions: resource.actions))
        }
    }
}

private extension SnapshotSupport {
    static func makeResourceWithAccessibilityMarkers (
        for scenario: Scenario,
        on device: SnapshotDevice,
        scale: CGFloat,
        keyWindow: UIWindow?,
        completion: @escaping (Resource) -> Void
    ) {
        withoutAnimation {
            let window = SnapshotWindow(scenario: scenario, device: device)
            let contentView = window.contentView!

            if let keyWindow = keyWindow {
                keyWindow.addSubview(window)
            }
            
            window.prepareForSnapshot {
                if contentView.bounds.size.width <= 0 {
                    fatalError("The view did laid out with zero width in scenario - \(scenario.name)", file: scenario.file, line: scenario.line)
                }
                
                if contentView.bounds.size.height <= 0 {
                    fatalError("The view did laied out with zero height in scenario - \(scenario.name)", file: scenario.file, line: scenario.line)
                }
               
                // Overlay snapshot with accessibility activation points and labels.
                // Use scenarioView instead of contentView due to issues with layoutIfNeeded for SwiftUI views.
                let scenarioView = window.scenarioView
                
                let accessibilityView = AccessibilitySnapshotView(
                    containedView: scenarioView,
                    viewRenderingMode: .renderLayerInContext,
                    activationPointDisplayMode: .always
                )
                
                accessibilityView.parseAccessibility(useMonochromeSnapshot: false)
                accessibilityView.sizeToFit()
                                
                makeResource(
                    for: accessibilityView,
                    on: device,
                    scale: scale,
                    keyWindow: keyWindow,
                    completion: completion
                )
            }
        }
    }
}
