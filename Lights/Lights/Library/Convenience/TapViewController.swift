import UIKit
import Ripple
import Walker
import Sugar

class TapViewController: UIViewController {

  struct Dimensions {
    static let offlineOffset: CGFloat = -50
  }

  lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGesture))

    return gesture
  }()

  lazy var gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = [Color.Background.top.CGColor, Color.Background.bottom.CGColor]
    layer.cornerRadius = 7

    return layer
  }()

  lazy var offlineView: OfflineView = {
    let view = OfflineView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.alpha = 0

    return view
  }()

  var reachability: Reachability?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.layer.insertSublayer(gradientLayer, atIndex: 0)
    view.addGestureRecognizer(tapGesture)
    view.addSubview(offlineView)

    setupGeneralConstraints()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    do {
      reachability = try Reachability.reachabilityForInternetConnection()
    } catch { return }

    NSNotificationCenter.defaultCenter().addObserver(
      self, selector: #selector(reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)

    do { try reachability?.startNotifier() } catch { return }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    gradientLayer.frame = view.bounds
  }

  // MARK: - Action methods

  func handleTapGesture() {
    let location = tapGesture.locationInView(view)

    droplet(location,
            view: view,
            size: 25,
            duration: 1, multiplier: 2.5,
            color: Color.General.ripple)
  }

  // MARK: - Constraints

  func setupGeneralConstraints() {
    NSLayoutConstraint.activateConstraints([
      offlineView.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
      offlineView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      offlineView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.offlineOffset)
      ])
  }

  // MARK: - Notifications

  func reachabilityChanged(notification: NSNotification) {
    guard let reachability = notification.object as? Reachability else { return }

    dispatch() {
      closeDistilleries()

      self.offlineView(!reachability.isReachable())
      self.presentViews(reachability.isReachable())
    }
  }

  // MARK: - Helper methods

  func presentViews(show: Bool = true) {
    view.subviews.forEach { view in
      guard view != self.offlineView else { return }

      UIView.animateWithDuration(0.5, animations: {
        view.alpha = show ? 1 : 0
        view.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeScale(2, 2)
      })
    }
  }

  func offlineView(show: Bool = true) {
    UIView.animateWithDuration(0.5, animations: {
      self.offlineView.transform = CGAffineTransformIdentity
      self.offlineView.alpha = show ? 1 : 0
    })
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
