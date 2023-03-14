import Foundation
import WebimClientLibraryUpdated

protocol WebimLogManagerObserver {
    func didGetNewLog(log: String)
}

protocol WebimLogManagerSubject {
    func add(observer: WebimLogManagerObserver)
    func remove(observer: WebimLogManagerObserver)
    func notify(with log: String)
}

class WebimLogManager: WebimLogManagerSubject {

    static let shared = WebimLogManager()

    var observerCollection = NSMutableSet()

    private var logs: [String]

    init() {
        logs = []
    }

    func getLogs() -> [String] {
        return logs
    }

    func add(observer: WebimLogManagerObserver) {
        observerCollection.add(observer)
    }

    func remove(observer: WebimLogManagerObserver) {
        observerCollection.remove(observer)
    }

    func notify(with log: String) {
        observerCollection.forEach { observer in
            guard let observer = observer as? WebimLogManagerObserver else { return }
            observer.didGetNewLog(log: log)
        }
    }
}

extension WebimLogManager: WebimLogger {
    func log(entry: String) {
        print(entry)
        logs.append(entry)
        notify(with: entry)
    }
}
