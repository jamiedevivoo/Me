import UIKit

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubclass()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubclass()
    }
}

// Convenience Initialiser
extension Button {
    convenience init(title:String, action: Selector, type: Button.ButtonVariety) {
        self.init()
        setTitle(title, for: .normal)
        addTarget(nil, action: action, for: .touchUpInside)
        customiseButton(for: type)
    }
}

// Custom Styling
extension Button {
    func setupSubclass() {
        self.setTitleColor(UIColor.app.button.primary.text(), for: .normal)
        self.titleLabel?.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 18)
        self.backgroundColor = UIColor.app.button.primary.fill()
        self.layer.borderColor = UIColor.app.button.primary.fill().cgColor
        self.contentEdgeInsets =  UIEdgeInsets(top: 6,left: 15,bottom: 6,right: 15)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0,height: 1.5)
    }
    
    func configureButton() {
        self.layer.cornerRadius = self.layer.bounds.height / 2
    }
    
    func customiseButton(for type: ButtonVariety) {
        if type == .secondary {
            self.setTitleColor(UIColor.app.button.primary.fill(), for: .normal)
            self.layer.borderColor = UIColor.app.button.primary.fill().cgColor
            self.backgroundColor = UIColor.clear
            self.layer.borderWidth = 2.0
            self.isEnabled = true
        } else if type == .disabled {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
            self.layer.borderColor = self.layer.borderColor?.copy(alpha: 0.5)
            self.isEnabled = false
        } else if type == .primary {
            self.backgroundColor = UIColor.app.button.primary.fill()
            self.layer.borderColor = UIColor.app.button.primary.fill().withAlphaComponent(0.5).cgColor
            self.isEnabled = true
        }
    }
}

extension Button {
    enum ButtonVariety {
        case primary, secondary, disabled
    }
    
}