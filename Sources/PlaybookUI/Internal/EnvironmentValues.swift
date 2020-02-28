import Playbook
import SwiftUI

internal struct GalleryDependency {
    var scheduler: SchedulerProtocol
    var context: ScenarioContext

    init(scheduler: SchedulerProtocol, context: ScenarioContext) {
        self.scheduler = scheduler
        self.context = context
    }
}

internal enum SnapshotColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: ColorScheme { .light }
}

internal enum GalleryDependencyEnvironmentKey: EnvironmentKey {
    static var defaultValue: GalleryDependency {
        GalleryDependency(
            scheduler: Scheduler(),
            context: ScenarioContext(
                snapshotWaiter: SnapshotWaiter(),
                isSnapshot: false,
                screenSize: UIScreen.main.bounds.size
            )
        )
    }
}

internal extension EnvironmentValues {
    var snapshotColorScheme: ColorScheme {
        get { self[SnapshotColorEnvironmentKey.self] }
        set { self[SnapshotColorEnvironmentKey.self] = newValue }
    }

    var galleryDependency: GalleryDependency {
        get { self[GalleryDependencyEnvironmentKey.self] }
        set { self[GalleryDependencyEnvironmentKey.self] = newValue }
    }
}
