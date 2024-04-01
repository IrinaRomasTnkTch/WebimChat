import Foundation
import WebimClientLibraryUpdated

class WebimServerSideSettingsManager {

    private var webimServerSideSettings: WebimServerSideSettings?

    func getServerSideSettings() {
        WebimServiceController.currentSession.getServerSideSettings(completionHandler: self)
    }

    func isGlobalReplyEnabled() -> Bool {
        guard let isGlobalReplyEnabled = webimServerSideSettings?.accountConfig.webAndMobileQuoting else {
            return false
        }
        return isGlobalReplyEnabled
    }

    func isMessageEditEnabled() -> Bool {
        guard let isMessageEditEnabled = webimServerSideSettings?.accountConfig.visitorMessageEditing else {
            return false
        }
        return isMessageEditEnabled
    }
    
    func disablingMessageInputField() -> Bool {
        guard let disablingMessageInputField = webimServerSideSettings?.accountConfig.disablingMessageInputField else {
            return false
        }
        return disablingMessageInputField
    }
}

extension WebimServerSideSettingsManager: ServerSideSettingsCompletionHandler {
    func onSuccess(webimServerSideSettings: WebimServerSideSettings) {
        self.webimServerSideSettings = webimServerSideSettings
    }

    func onFailure() {

    }

}
