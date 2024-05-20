import Playbook
import SwiftUI

@MainActor
internal final class ImageLoader: ObservableObject {
    private let imageCache = ImageCache()
    private var queue = ContiguousArray<QueueItem>()
    private var sequentiallyProcessedCount = 0

    func loadImage(for source: ImageSource) async -> UIImage? {
        if let data = imageCache.data(for: source) {
            return UIImage(data: data)
        }
        else {
            let item = QueueItem(source: source)
            queue.append(item)

            return await withTaskCancellationHandler {
                await withCheckedContinuation { continuation in
                    item.continuation = continuation

                    if queue.count == 1 {
                        start()
                    }
                }
            } onCancel: {
                item.isCancelled = true
                item.continuation?.resume(returning: nil)
                item.continuation = nil
            }
        }
    }
}

private extension ImageLoader {
    final class QueueItem {
        let source: ImageSource
        var continuation: CheckedContinuation<UIImage?, Never>?
        var isCancelled = false

        init(source: ImageSource) {
            self.source = source
        }
    }

    func start() {
        guard let item = queue.first else {
            return sequentiallyProcessedCount = 0
        }

        guard !item.isCancelled else {
            return startNext()
        }

        sequentiallyProcessedCount += 1

        // Perform snapshotting in `default` mode to avoid blocking UI tracking events.
        RunLoop.main.perform(inModes: [.default]) { [weak self] in
            guard let self else {
                return
            }

            guard !item.isCancelled else {
                return startNext()
            }

            SnapshotSupport.data(
                for: item.source.scenario,
                on: SnapshotDevice(
                    name: item.source.scenario.title.rawValue,
                    size: item.source.size,
                    traitCollection: UITraitCollection(
                        traitsFrom: [
                            UITraitCollection(userInterfaceStyle: item.source.colorScheme.userInterfaceStyle),
                            UITraitCollection(horizontalSizeClass: .compact),
                            UITraitCollection(verticalSizeClass: .regular),
                            UITraitCollection(layoutDirection: .leftToRight),
                            UITraitCollection(preferredContentSizeCategory: .large),
                        ]
                    )
                ),
                format: .png,
                maxSize: item.source.size,
                scale: item.source.scale
            ) { [weak self] data in
                guard let self else {
                    return
                }

                let image = UIImage(data: data)
                item.continuation?.resume(returning: image)
                item.continuation = nil
                imageCache.create(file: data, for: item.source)
                startNext()
            }
        }
    }

    func startNext() {
        guard !queue.isEmpty else {
            return
        }

        if sequentiallyProcessedCount < 3 {
            queue.removeFirst()
            start()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self else {
                    return
                }

                sequentiallyProcessedCount = 0
                queue.removeFirst()
                start()
            }
        }
    }
}

private extension ColorScheme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light

        case .dark:
            return .dark

        @unknown default:
            return .unspecified
        }
    }
}
