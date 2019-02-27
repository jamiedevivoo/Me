import UIKit
import SnapKit
import Firebase

class HomeViewController: LoggedInViewController {
    
    // MARK: - Properties
    
    var ref: DocumentReference!
    
    let profiles = FirebaseAPI.getProfiles()
    
    // MARK: - UI and Views
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(HomeViewController.buttonTapped), for: .touchUpInside)
        button.setTitle("View Friends Profile", for: .normal)
        return button
    }()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var profilesTableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        return table
    }()
    
    var user: User?
    
    // MARK: - Init and ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOG: Dashboard Created")
        
        profilesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        
        setup()
        setupConstraints()
        
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        db.collection("user").document(uid).getDocument() { document, error in
            if let error = error {
                print(error)
            } else {
                if let document = document {
                    self.user = User(snapshot: document)
                }
                self.user = User(snapshot: document as! DocumentSnapshot)
            }
        
        self.welcomeLabel.text = "Welcome \(self.user?.name ?? "No Value")"
        }
    }
    
    func setup() {
        navigationItem.title = "Home"
        
        self.view.addSubview(profilesTableView)
        self.view.addSubview(mainButton)
        self.view.addSubview(welcomeLabel)
    }
    
    func setupConstraints() {
        self.profilesTableView.snp.makeConstraints{ (make) in
            make.size.equalTo(self.view)
        }
        self.mainButton.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.width.equalTo(200)
            make.center.equalTo(self.view)
        }
        self.welcomeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.top.equalTo(100)
            make.left.right.equalTo(0)
        }
    }
    // MARK: - Actions
    
    @objc func buttonTapped() {
        print("Button Tapped")
        let friendsProfileViewController = ProfileViewController()
        friendsProfileViewController.view.backgroundColor = .yellow
        friendsProfileViewController.title = "Friends Profile"
        navigationController?.pushViewController(friendsProfileViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = profiles[indexPath.row].name
        return cell
    }
}
