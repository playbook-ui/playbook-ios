import Combine
import Foundation

internal final class SerialMainDispatcher {
    private struct Resource {
        var queue = ContiguousArray<DispatchWorkItem>()
        var cancellable: AnyCancellable?
    }

    private let interval: TimeInterval

    @Atomic
    private var resource = Resource()

    private var scheduler: SchedulerProtocol

    init(interval: TimeInterval, scheduler: SchedulerProtocol) {
        self.interval = interval
        self.scheduler = scheduler
    }

    func dispatch(block: @escaping () -> Void) -> AnyCancellable {
        let workItem = DispatchWorkItem(block: block)
        let shouldStart: Bool = _resource.modify { resource in
            let isEmpty = resource.queue.isEmpty
            resource.queue.append(workItem)
            return isEmpty
        }

        if shouldStart {
            executeNext()
        }

        return AnyCancellable(workItem.cancel)
    }

    func cancel() {
        resource = Resource()
    }
}

private extension SerialMainDispatcher {
    func executeNext() {
        let nextWorkItem: DispatchWorkItem? = _resource.modify { resource in
            guard let workItem = resource.queue.first else { return nil }

            if workItem.isCancelled {
                resource.queue.removeFirst()
                return workItem
            }
            else {
                resource.cancellable = AnyCancellable(workItem.cancel)
                return workItem
            }
        }

        guard let workItem = nextWorkItem else {
            return
        }

        guard !workItem.isCancelled else {
            return executeNext()
        }

        scheduler.schedule(on: .main, after: interval) { [weak self] in
            guard let self = self else { return }

            if !workItem.isCancelled {
                workItem.perform()
            }

            self._resource.modify {
                guard !$0.queue.isEmpty else { return }
                $0.queue.removeFirst()
            }

            self.executeNext()
        }
    }
}
