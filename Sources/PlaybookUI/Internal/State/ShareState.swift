import Playbook
import SwiftUI

@MainActor
internal final class ShareState: ObservableObject {
    weak var scenarioViewController: ScenarioViewController?

    func shareSnapshot() {
        guard let scenarioViewController else {
            return
        }

        let bounds = scenarioViewController.view.bounds
        let image = UIGraphicsImageRenderer(bounds: bounds).image { _ in
            scenarioViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        if !Bundle.main.hasPhotoLibraryAddUsageDescription {
            activityViewController.excludedActivityTypes = [.saveToCameraRoll]
        }

        activityViewController.popoverPresentationController?.sourceView = scenarioViewController.view
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        scenarioViewController.present(activityViewController, animated: true)
    }
}

private extension Bundle {
    var hasPhotoLibraryAddUsageDescription: Bool {
        let usage = object(forInfoDictionaryKey: "NSPhotoLibraryAddUsageDescription") as? String
        return usage.map { !$0.isEmpty } ?? false
    }
}
