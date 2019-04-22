import UIKit

protocol UpdateAccountViews {
    var accountDependantViews: [UIView] { get }
}

protocol AccountInfoObject { }

protocol OnboardingDelegate: class {
    func setData(_ dataDict: [String:String])
    func isOnboardingComplete() -> Bool
    func finishOnboarding()
}
