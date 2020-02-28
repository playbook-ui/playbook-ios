import SwiftUI

internal protocol SchedulerProtocol {
    func schedule(on: DispatchQueue, action: @escaping () -> Void)
    func schedule(on: DispatchQueue, after interval: TimeInterval, action: @escaping () -> Void)
}

internal struct Scheduler: SchedulerProtocol {
    func schedule(on queue: DispatchQueue, action: @escaping () -> Void) {
        queue.async(execute: action)
    }

    func schedule(on queue: DispatchQueue, after interval: TimeInterval = 0, action: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + interval, execute: action)
    }
}
