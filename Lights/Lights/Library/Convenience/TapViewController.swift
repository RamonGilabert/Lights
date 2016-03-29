import UIKit
import Ripple

class TapViewController: UIViewController {

  lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGesture))

    return gesture
  }()

  lazy var gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = [Color.Background.top.CGColor, Color.Background.bottom.CGColor]
    layer.cornerRadius = 6

    return layer
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = Color.Background.general
    view.layer.insertSublayer(gradientLayer, atIndex: 0)
    view.addGestureRecognizer(tapGesture)
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

  // MARK: - Helper methods

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
