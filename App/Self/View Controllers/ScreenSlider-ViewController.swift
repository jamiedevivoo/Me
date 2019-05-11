import UIKit
import SnapKit
import SwiftyJSON

class ScreenSliderViewController: UIPageViewController {
    
    // MARK: - Properties
    /// SliderDelegate
    weak var screenSliderDelegate: ScreenSliderDelegate?
    
    /// Page Indicator View
    lazy var pageIndicator: PageIndicator = PageIndicator()
    
    /// Accessing UIPageViewController's child ScrollView
    var scrollView: UIScrollView?
    
    /// References to all screens in slider. (The View, enabled)
    var screens: [(vc: UIViewController, enabled: Bool)] = [] {
        didSet {
            self.pageIndicator.numberOfPages = self.screens.filter({$0.enabled == true}).count
        }
    }
    
    /// Options for Screen Slider setup
    var initialScreenIndex: Int = 0
    var sliderShouldloop: Bool = false
    
    var forwardNavigationEnabled: Bool = true
    var backwardNavigationEnabled: Bool = true

    var isLiveGestureSwipingEnabled: Bool = true {
        didSet { scrollView?.isScrollEnabled = isLiveGestureSwipingEnabled }
    }
    var pageIndicatorEnabled: Bool = false {
        didSet { setupPageIndicator()  }
    }
    
    // MARK: - Init
    /// Helper Initialiser for setting up the superClass UIPageViewController
    init(navigationOrientation: NavigationOrientation = .horizontal) {
        super.init(
            transitionStyle: UIPageViewController.TransitionStyle.scroll,
            navigationOrientation: navigationOrientation,
            options: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Overriding Methods
extension ScreenSliderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }
    
}

// MARK: - Setup Methods
extension ScreenSliderViewController {
    
    /// Start setting up the child views
    private func setup() {
        view.backgroundColor = UIColor.App.Background.primary()
        setupPageView()
        setupPageIndicator()
        setupScrollView()
    }
    
    /// Setup the initial page
    private func setupPageView() {
        guard screens.count > 0 else { return }
        setViewControllers([screens[initialScreenIndex].vc], direction: .forward, animated: true, completion: nil)
    }
    
    /// Setup the pageIndicator
    private func setupPageIndicator() {
        guard pageIndicatorEnabled == true else { return }
        self.pageIndicator.numberOfPages = self.screens.filter({$0.enabled == true}).count
        self.pageIndicator.currentPage = initialScreenIndex
        
        self.view.addSubview(pageIndicator)
        
        switch navigationOrientation {
        case .horizontal:
            pageIndicator.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
                make.centerX.equalToSuperview()
                make.height.equalTo(10)
            }
            return
        case .vertical:
            pageIndicator.snp.makeConstraints { (make) in
                make.right.equalTo(self.view.safeAreaLayoutGuide).offset(65)
                make.centerY.equalToSuperview()
                make.height.equalTo(10)
                make.width.equalTo(200)
            }
            pageIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        }
    }
    /// Setup the ScrollView
    private func setupScrollView() {
        self.scrollView = (view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView)
        scrollView?.delegate = self
        scrollView?.isScrollEnabled = isLiveGestureSwipingEnabled
    }
}

// MARK: - Class Methods
extension ScreenSliderViewController {
    
    // Manually transition to the next screen
    func goToNextScreen() {
        guard let screen = pageViewController(self, viewControllerAfter: viewControllers![0]) else { return }
        setViewControllers([screen], direction: .forward, animated: true, completion: nil)
        pageIndicator.currentPage = screens.firstIndex(where: {$0.vc == viewControllers![0]})!
        print(self)
    }
    
    // Manually transition to the previous screen
    func goToPreviousScreen() {
        guard let screen: UIViewController = pageViewController(self, viewControllerBefore: viewControllers![0]) else { return }
        setViewControllers([screen], direction: .reverse, animated: true, completion: nil)
        pageIndicator.currentPage = screens.firstIndex(where: {$0.vc == viewControllers![0]})!
        print(self)
    }
}

// MARK: - UIPageViewControllerDataSourceDelegate  Methods
extension ScreenSliderViewController: UIPageViewControllerDataSource {
    
    // Deciding the next viewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        /// If the current viewController doesn't exists in screens, bail.
        guard let viewControllerIndex: Int = screens.firstIndex(where: {$0.vc == viewControllers![0]}) else { return nil }
        
        /// Make sure this isn't the last slide (otherwise we'll need to see if looping is enabled
        if viewControllerIndex < (self.screens.count - 1) {
            /// If forward navigation isn't enabled, bail.
            guard forwardNavigationEnabled else { return nil }
            
            /// Get the remaining screens in the sequence
            let remainingScreens = screens[(viewControllerIndex+1)...]
            
            /// Get the next screen that is enabled
            guard let nextEnabledScreen = remainingScreens.first(where: {$0.enabled == true})?.vc else { return nil }
            
            /// Check the delegate for validation, then go forward one slide (if the delegate doesn't exist, assume it's allowed.
            guard let sliderDelegate = screenSliderDelegate else { return nextEnabledScreen }
            guard sliderDelegate.validateDataBeforeNextScreen(currentViewController: viewController, nextViewController: nextEnabledScreen) else { return nil }
            
            return nextEnabledScreen
        } else {
            /// Otherwise if looping is enabled, go to the first slide.
            guard !sliderShouldloop else { return self.screens.last(where: {$0.enabled == true})?.vc }
            /// If looping is disabled, there is nothing to do.
            return nil
        }
    }
    
    // Deciding the previous viewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        /// If the current viewController doesn't exists in screens, bail.
        guard let viewControllerIndex: Int = screens.firstIndex(where: {$0.vc == viewControllers![0]}) else { return nil }

        /// If backward navigation isn't enabled, bail.
        guard backwardNavigationEnabled else { return nil }
        
        /// Get the previous screens in the sequence
        let previousScreens = screens[...(viewControllerIndex-1)]
        
        /// If this isn't the first slide, get the first previous enabled screen.
        if viewControllerIndex > 0 { return previousScreens.last(where: {$0.enabled == true})?.vc }
        
        /// Otherwise if looping is enabled, go to the last slide.
        guard !sliderShouldloop else { return screens.first(where: {$0.enabled == true})?.vc }
        
        /// If looping is disabled, there is nothing to do.
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate  Methods
extension ScreenSliderViewController: UIPageViewControllerDelegate {
    
    // The PageViewController is about to transition
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    }
    
    // The pageViewController finished the transition
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        /// Set the pageControl.currentPage to the index of the current viewController in screens
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.screens.firstIndex(where: {$0.vc == viewControllers[0]}) {
                self.pageIndicator.currentPage = viewControllerIndex
            }
        }
    }
    
}

// MARK: - ScrollView Delegate Methods
extension ScreenSliderViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
}