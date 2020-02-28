import Combine
import SwiftUI

internal final class ScenarioDisplayStore {
    let data: SearchedData
    let snapshotLoader: SnapshotLoaderProtocol
    let serialDispatcher: SerialMainDispatcher
    let isVisible = CurrentValueSubject<Bool, Never>(false)

    private let scheduler: SchedulerProtocol

    @Atomic
    private var cancellables = Set<AnyCancellable>()

    init(
        data: SearchedData,
        snapshotLoader: SnapshotLoaderProtocol,
        serialDispatcher: SerialMainDispatcher,
        scheduler: SchedulerProtocol = Scheduler()
    ) {
        self.data = data
        self.snapshotLoader = snapshotLoader
        self.serialDispatcher = serialDispatcher
        self.scheduler = scheduler
    }

    func loadImage(into status: Binding<ScenarioDisplay.Status>) {
        guard !status.wrappedValue.isLoaded else { return }

        asyncLoadSnapshot()
            .flatMap { [weak self] status -> AnyPublisher<ScenarioDisplay.Status, Never> in
                switch status {
                case .loaded, .failed:
                    return Just(status)
                        .eraseToAnyPublisher()

                case .default, .waitForSnapshot:
                    guard let asyncTakeSnapshot = self?.asyncTakeSnapshot else {
                        return Empty().eraseToAnyPublisher()
                    }

                    return Deferred(createPublisher: asyncTakeSnapshot)
                        .merge(with: Just(status))
                        .eraseToAnyPublisher()
                }
            }
            .assign(to: \.wrappedValue, on: status)
            .store(in: &cancellables)
    }

    func cancellAll() {
        _cancellables.modify { $0.removeAll() }
    }
}

private extension ScenarioDisplayStore {
    func asyncLoadSnapshot() -> Future<ScenarioDisplay.Status, Never> {
        func run() -> ScenarioDisplay.Status {
            let result = snapshotLoader.loadImage(kind: data.kind, name: data.scenario.name)

            switch result {
            case .success(let image?):
                return .loaded(image: image)

            case .success(.none):
                return .waitForSnapshot

            case .failure:
                return .failed
            }
        }

        let scheduler = self.scheduler

        return Future { fulfill in
            scheduler.schedule(on: .imageLoadQueue) {
                fulfill(.success(run()))
            }
        }
    }

    func asyncTakeSnapshot() -> Future<ScenarioDisplay.Status, Never> {
        Future { [weak self] fulfill in
            guard let self = self else {
                return fulfill(.success(.default))
            }

            self._cancellables.modify { cancellables in
                let cancellable = self.serialDispatcher.dispatch {
                    self.snapshotLoader.takeSnapshot(for: self.data.scenario, kind: self.data.kind) { data in
                        let status: ScenarioDisplay.Status = UIImage(data: data).map { .loaded(image: $0) } ?? .failed
                        fulfill(.success(status))
                    }
                }
                cancellables.insert(cancellable)
            }
        }
    }
}

private extension DispatchQueue {
    static let imageLoadQueue = DispatchQueue(
        label: "app.playbook-ui.ScenarioDisplay.imageLoadQueue",
        qos: .userInitiated,
        attributes: .concurrent,
        autoreleaseFrequency: .workItem
    )
}
