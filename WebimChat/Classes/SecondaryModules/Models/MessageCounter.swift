import Foundation
import WebimClientLibraryUpdated

protocol MessageCounterDelegate: AnyObject {
    func changed(newMessageCount: Int)
    func updateLastMessageIndex(completionHandler: ((Int) -> ())?)
    func updateLastReadMessageIndex(completionHandler: ((Int) -> ())?)
}

class MessageCounter {

    var lastReadMessageIndex: Int
    private var lastMessageIndex: Int
    private var actualNewMessageCount: Int

    private weak var delegate: MessageCounterDelegate?

    init(delegate: MessageCounterDelegate? = nil) {
        self.delegate = delegate
        self.lastMessageIndex = 0
        self.lastReadMessageIndex = 0
        self.actualNewMessageCount = 0
    }

    func set(lastReadMessageIndex: Int) {
        if lastReadMessageIndex > self.lastReadMessageIndex {
            self.lastReadMessageIndex = lastReadMessageIndex
            updateActualNewMessageCount()
        }
    }

    func set(lastMessageIndex: Int) {
        self.lastMessageIndex = lastMessageIndex
        updateActualNewMessageCount()
    }

    func getActualNewMessageCount() -> Int {
        return actualNewMessageCount
    }

    func hasNewMessages() -> Bool {
        return actualNewMessageCount > 0
    }

    func firstUnreadMessageIndex() -> Int {
        return lastReadMessageIndex + 1
    }

    func increaseLastReadMessageIndex(with count: Int) {
        self.lastReadMessageIndex += count
    }

    private func updateActualNewMessageCount() {
        if actualNewMessageCount != lastMessageIndex - lastReadMessageIndex {
            actualNewMessageCount = max(lastMessageIndex - lastReadMessageIndex, 0)
            delegate?.changed(newMessageCount: actualNewMessageCount)
        }
    }
}

extension MessageCounter: UnreadByVisitorMessageCountChangeListener {
    func changedUnreadByVisitorMessageCountTo(newValue: Int) {
        delegate?.updateLastMessageIndex() { [weak self] index in
            self?.set(lastMessageIndex: index)
        }
        delegate?.updateLastReadMessageIndex() { [weak self] index in
            self?.set(lastReadMessageIndex: index)
        }
    }
}
