import UIKit
import WebimClientLibraryUpdated

class WebimServiceController {
    
    static let shared = WebimServiceController()
    
    private var webimService: WebimService?
    
    weak var fatalErrorHandlerDelegate: FatalErrorHandlerDelegate?
    weak var departmentListHandlerDelegate: DepartmentListHandlerDelegate?
    weak var notFatalErrorHandler: NotFatalErrorHandler?
    
    func createSession() -> WebimService {
        
        stopSession()
        print("createSession")
        let service = WebimService(
            fatalErrorHandlerDelegate: self,
            departmentListHandlerDelegate: self,
            notFatalErrorHandler: self
        )
        
        service.createSession()
        service.startSession()
        service.setMessageStream()
        
        self.webimService = service
        return service
    }
    
    static var currentSession: WebimService {
        return WebimServiceController.shared.currentSession()
    }
    
    func currentSession() -> WebimService {
        return self.webimService ?? createSession()
    }
    
    func stopSession() {
        print("stopSession")
        self.webimService?.stopSession()
        self.webimService = nil
    }
    
    func sessionState() -> ChatState {
        return webimService?.sessionState() ?? .unknown
    }
    
    static func checkMainThread() {
        if !Thread.isMainThread {
#if DEBUG
            fatalError("Not main thread error")
#else
            print("Not main thread error")
#endif
        }
    }
    
    static var keyboardWindow: UIWindow? {
        
        let windows = UIApplication.shared.windows
        if let keyboardWindow = windows.first(where: { NSStringFromClass($0.classForCoder) == "UIRemoteKeyboardWindow" }) {
          return keyboardWindow
        }
        return nil
    }
    
    static func keyboardHidden(_ hidden: Bool) {
        DispatchQueue.main.async {
            WebimServiceController.keyboardWindow?.isHidden = hidden
        }
    }
}

extension WebimServiceController: FatalErrorHandlerDelegate {
    
    func showErrorDialog(withMessage message: String) {
        self.fatalErrorHandlerDelegate?.showErrorDialog(withMessage: message)
    }
}

extension WebimServiceController: DepartmentListHandlerDelegate {
    
    func showDepartmentsList(_ departaments: [Department], action: @escaping (String) -> Void ) {
        self.departmentListHandlerDelegate?.showDepartmentsList(departaments, action: action)
    }
}

extension WebimServiceController: NotFatalErrorHandler {
    
    func on(error: WebimNotFatalError) {
        self.notFatalErrorHandler?.on(error: error)
    }
    
    func connectionStateChanged(connected: Bool) {
        self.notFatalErrorHandler?.connectionStateChanged(connected: connected)
    }
}
