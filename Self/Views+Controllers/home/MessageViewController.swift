//
//  MessageContainerViewController.swift
//  Self
//
//  Created by Jamie De Vivo (i7436295) on 04/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit
import SnapKit

class MessageViewController: UIViewController {
    
    let messageView = UIView()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.ultraLight)
        label.textColor = UIColor.app.solidText()
        label.text = "Good Morning, "
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = user?.name
        label.font = UIFont.systemFont(ofSize: 46, weight: UIFont.Weight.bold)
        label.textColor = UIColor.app.solidText()
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
        label.text = "Did you know Mondays are your happiest days? Let’s rock today!"
        label.textColor = UIColor.app.solidText()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var messageResponseButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .fillProportionally // .fillEqually .fillProportionally .equalSpacing .equalCentering
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    lazy var messageResponseOne: UIButton = {
        let button = DashboardButton()
        button.setTitle("💪", for: .normal)
        button.addTarget(self, action: #selector(MessageViewController.logNewMood), for: .touchUpInside)
        return button
    }()
    
    lazy var messageResponseTwo: UIButton = {
        let button = DashboardButton()
        button.setTitle("😔", for: .normal)
        button.addTarget(self, action: #selector(MessageViewController.messageResponse), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var user: UserInfo?
    var message = Message()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addConstraints()
    }
    
    // MARK: - Functions
    
    @objc func logNewMood() {
        navigationController?.pushViewController(AddMoodViewController(), animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func messageResponse() {
    }
    
}
extension MessageViewController: ViewBuilding {
    func addSubViews() {
        
        self.view.addSubview(messageView)
            messageView.addSubview(greetingLabel)
            messageView.addSubview(nameLabel)
            messageView.addSubview(messageLabel)
            messageView.addSubview(messageResponseButtonStack)
                messageResponseButtonStack.addArrangedSubview(messageResponseOne)
                messageResponseButtonStack.addArrangedSubview(messageResponseTwo)
    }
    
    func addConstraints() {
        messageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.height.greaterThanOrEqualTo(100)
            make.left.right.equalToSuperview()
        }
            greetingLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalToSuperview()
            }
            nameLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(greetingLabel.snp.bottom).inset(5)
                make.width.equalToSuperview()
            }
            messageLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.width.equalToSuperview()
            }
            messageResponseButtonStack.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.width.equalToSuperview()
            }
    }
}
