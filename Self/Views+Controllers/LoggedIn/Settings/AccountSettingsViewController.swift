import UIKit
import SnapKit
import Firebase

class AccountSettingsViewController: UIViewController {
    
    
    // MARK: - Properties
    var user: UserData!
    
    // MARK: - SubViews
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.app.background.secondaryBackground()
        return view
    }()
    lazy var pageTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Use this page to modify the settings related to your account."
        label.textAlignment = .left
        label.textColor = UIColor.app.text.solidText()
        label.numberOfLines = 0
        
        return label
    }()
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        return textField
    }()
    lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update Details", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.app.button.primary.fill()
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.app.button.primary.fill().cgColor
        button.addTarget(self, action: #selector(AccountSettingsViewController.saveButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account Settings"
        view.backgroundColor = UIColor.app.background.primaryBackground()
        self.hideKeyboardWhenTappedAround()
        addSubViews()
        addConstraints()
        
        self.user = AccountManager.shared().account!.user
        updateFields()
    }
    
    
    // MARK: - Functions
    
    func updateFields() {
        if let name = self.user?.name {
            self.nameTextField.text = name
        }
        if let email = Auth.auth().currentUser?.email {
            self.emailTextField.text = email
        }
    }
    
    // MARK: - Actions
    
        @objc func saveButtonAction(_ sender: Any) {
            
            guard let name = nameTextField.text, let email = emailTextField.text else { return }
            AccountManager.shared().account?.user.name = name
            AccountManager.shared().updateAccount()

//            let user = Auth.auth().currentUser
//            var credential: AuthCredential
            
//            Auth.auth().currentUser?.updateEmail(to: email) { (error) in
//                if let _ = error {
//                    print ("\(String(describing: error))")
//                } else {
//                    AccountManager.shared().updateUser()
//                }
//            }
            
//            Auth.auth().currentUser?.reauthenticate(with: email, completion: {
//                [weak self]
//                (error) in
//            })
//            let credential = EmailAuthProvider.credential(withEmail: "email", password: "pass")
//
//            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (error) in
//                if let error = error {
//                    // An error happened.
//                } else {
//                    // User re-authenticated.
//                }
//            }
        }
    }
    
extension AccountSettingsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountSettingsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AccountSettingsViewController: ViewBuilding {
    
    func addSubViews() {
        self.view.addSubview(topView)
            topView.addSubview(pageTipLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(updateButton)
    }
    
    func addConstraints() {
        topView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.greaterThanOrEqualTo(pageTipLabel.snp.height).offset(150)
        }
        pageTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topView.snp.left).offset(20)
            make.right.equalTo(topView.snp.right).offset(-20)
            make.top.equalTo(topView.snp.top).offset(100)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(view.snp.centerY)
        }
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        updateButton.snp.makeConstraints { (make) in
            make.size.equalTo(nameTextField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
        }
    }
}