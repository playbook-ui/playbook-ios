import SwiftUI

@testable import PlaybookUI

struct GalleryScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Gallery") {
            Scenario("Ready", layout: .fill) { context in
                PlaybookGalleryInternal(
                    name: "TEST",
                    snapshotColorScheme: .light,
                    store: GalleryStore(
                        playbook: .test,
                        preSnapshotCountLimit: 100,
                        screenSize: context.screenSize.portrait,
                        userInterfaceStyle: .light,
                        status: .ready
                    )
                        .takeSnapshots()
                        .start()
                )
                    .environment(
                        \.galleryDependency,
                        GalleryDependency(
                            scheduler: SchedulerMock(),
                            context: context
                        )
                    )
            }

            Scenario("Preparing", layout: .fill) { context in
                PlaybookGalleryInternal(
                    name: "TEST",
                    snapshotColorScheme: .light,
                    store: GalleryStore(
                        playbook: .test,
                        preSnapshotCountLimit: 0,
                        screenSize: context.screenSize.portrait,
                        userInterfaceStyle: .light
                    )
                        .start()
                )
            }

            Scenario("Empty", layout: .fill) { context in
                PlaybookGalleryInternal(
                    name: "TEST",
                    snapshotColorScheme: .light,
                    store: GalleryStore(
                        playbook: Playbook(),
                        preSnapshotCountLimit: 0,
                        screenSize: context.screenSize.portrait,
                        userInterfaceStyle: .light
                    )
                )
                    .environment(
                        \.galleryDependency,
                        GalleryDependency(
                            scheduler: SchedulerMock(),
                            context: context
                        )
                    )
            }

            Scenario("Searching", layout: .fill) { context in
                PlaybookGalleryInternal(
                    name: "TEST",
                    snapshotColorScheme: .light,
                    store: GalleryStore(
                        playbook: .test,
                        preSnapshotCountLimit: 100,
                        screenSize: context.screenSize.portrait,
                        userInterfaceStyle: .light,
                        status: .ready
                    )
                        .takeSnapshots()
                        .start(with: "2")
                )
                    .environment(
                        \.galleryDependency,
                        GalleryDependency(
                            scheduler: SchedulerMock(),
                            context: context
                        )
                    )
            }

            Scenario("Dark snapshots", layout: .fill) { context in
                PlaybookGalleryInternal(
                    name: "TEST",
                    snapshotColorScheme: .dark,
                    store: GalleryStore(
                        playbook: .test,
                        preSnapshotCountLimit: 100,
                        screenSize: context.screenSize.portrait,
                        userInterfaceStyle: .dark,
                        status: .ready
                    )
                        .takeSnapshots()
                        .start()
                )
                    .environment(
                        \.galleryDependency,
                        GalleryDependency(
                            scheduler: SchedulerMock(),
                            context: context
                        )
                    )
            }

            Scenario("Sheet", layout: .fill) { context in
                ScenarioDisplaySheet(data: .stub, onClose: {})
                    .environmentObject(
                        GalleryStore(
                            playbook: .test,
                            preSnapshotCountLimit: 0,
                            screenSize: context.screenSize.portrait,
                            userInterfaceStyle: .light
                        )
                    )
            }

            Scenario("Display list", layout: .fillH) { context in
                ScenarioDisplayList(
                    data: SearchedListData(
                        kind: "Long Kind Long Kind Long Kind Long Kind",
                        shouldHighlight: true,
                        scenarios: [.stub, .stub, .stub]
                    ),
                    safeAreaInsets: EdgeInsets(),
                    serialDispatcher: SerialMainDispatcher(interval: 0, scheduler: Scheduler()),
                    onSelect: { _ in }
                )
                    .environmentObject(
                        GalleryStore(
                            playbook: .test,
                            preSnapshotCountLimit: 0,
                            screenSize: context.screenSize.portrait,
                            userInterfaceStyle: .light
                        )
                    )
            }

            Scenario("Display empty", layout: .compressed) { context in
                ScenarioDisplay(
                    store: ScenarioDisplayStore(
                        data: SearchedData(
                            scenario: .stub("Long Name Long Name Long Name"),
                            kind: "Kind",
                            shouldHighlight: true
                        ),
                        snapshotLoader: SnapshotLoaderMock(
                            device: SnapshotDevice(name: "TEST", size: context.screenSize.portrait),
                            loadImageResult: .success(nil)
                        ),
                        serialDispatcher: SerialMainDispatcher(interval: 0, scheduler: SchedulerMock()),
                        scheduler: SchedulerMock()
                    )
                )
            }

            Scenario("Display failure", layout: .compressed) { context in
                ScenarioDisplay(
                    store: ScenarioDisplayStore(
                        data: .stub,
                        snapshotLoader: SnapshotLoaderMock(
                            device: SnapshotDevice(name: "TEST", size: context.screenSize.portrait),
                            loadImageResult: .failure(TestError())
                        ),
                        serialDispatcher: SerialMainDispatcher(interval: 0, scheduler: SchedulerMock()),
                        scheduler: SchedulerMock()
                    )
                )
            }

            Scenario("Display failure dark", layout: .compressed) { context in
                ScenarioDisplay(
                    store: ScenarioDisplayStore(
                        data: .stub,
                        snapshotLoader: SnapshotLoaderMock(
                            device: SnapshotDevice(name: "TEST", size: context.screenSize.portrait),
                            loadImageResult: .failure(TestError())
                        ),
                        serialDispatcher: SerialMainDispatcher(interval: 0, scheduler: SchedulerMock()),
                        scheduler: SchedulerMock()
                    )
                )
                    .environment(\.snapshotColorScheme, .dark)
            }
        }
    }
}

private struct TestError: Error {}

private extension CGSize {
    var portrait: CGSize {
        CGSize(width: min(width, height), height: max(width, height))
    }
}
