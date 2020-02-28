import SwiftUI

internal struct ImageSharingView: UIViewControllerRepresentable {
    struct Item: Identifiable {
        var id: Int { image.hash }
        var image: UIImage
    }

    var item: Item
    var onComplete: () -> Void

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let uiViewController = UIActivityViewController(
            activityItems: [item.image],
            applicationActivities: nil
        )
        if !Bundle.main.hasPhotoLibraryAddUsageDescription {
            uiViewController.excludedActivityTypes = [.saveToCameraRoll]
        }
        return uiViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        uiViewController.completionWithItemsHandler = { _, _, _, _ in
            self.onComplete()
        }
    }
}

private extension Bundle {
    var hasPhotoLibraryAddUsageDescription: Bool {
        let usage = object(forInfoDictionaryKey: "NSPhotoLibraryAddUsageDescription") as? String
        return usage.map { !$0.isEmpty } ?? false
    }
}
