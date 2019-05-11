import UIKit
import SnapKit
import Firebase

class FeedViewController: UIViewController {
    lazy var actionListViewController = FeedActionListChildViewController(accountRef: AccountManager.shared().accountRef!)
    lazy var messageViewController = FeedMessageChildViewController(accountRef: AccountManager.shared().accountRef!)
}

// MARK: - Overrides
extension FeedViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupChildViews()
        
        let collectionRef = Firestore.firestore().collection("user").document(Auth.auth().currentUser!.uid).collection("mood_logs")
        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                if let error = error { print("Error Loading User Data: \(error.localizedDescription)") }
                return
            }
            print(snapshot)
            for document in snapshot.documents {
                var documentData = document.data()
                documentData["uid"] = document.documentID
                print(documentData as AnyObject)
                print(Mood.Log(documentData).dictionary as AnyObject)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.returnedToRootView()
    }
}

// MARK: - View Building
extension FeedViewController: ViewBuilding {
    
    func setTabBarItem() {
        navigationController?.title = nil
        navigationController?.tabBarItem.image = UIImage(named: "head-icon")
    }
    
    func addSubViews() {
        add(actionListViewController)
        add(messageViewController)
        self.view.addSubview(messageViewController.view)
        self.view.addSubview(actionListViewController.view)
    }
    
    func setupChildViews() {
        messageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(30)
            make.bottom.equalTo(actionListViewController.view.snp.top).offset(-20)
            make.height.greaterThanOrEqualTo(messageViewController.messageStackView.snp.height).priority(.required)
        }
        actionListViewController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(30)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(30)
            make.height.equalTo(actionListViewController.actionButtonStack.snp.height).offset(50)
        }
    }
}
