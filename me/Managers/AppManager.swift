import UIKit
import Firebase

class AppManager {
    
    
    // MARK: - Properties
    
    static let shared = AppManager()
    var appContainer: AppContainerViewController!
    
    
    // MARK: - Init
    private init() { }
    
    
    // MARK: - Functions
    
    func showApp() {
        if Auth.auth().currentUser == nil {
            appContainer.present(LaunchNavigationController(), animated: true, completion: nil)
        } else {
            AccountManager.shared.loadUser { [unowned self] in
                self.appContainer.present(HomeTabBarController(), animated: true, completion: nil)
            }
        }
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}