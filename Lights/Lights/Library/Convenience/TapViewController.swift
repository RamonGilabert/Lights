import UIKit
import Ripple

class TapViewController: UIViewController {

  lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGesture))

    return gesture
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addGestureRecognizer(tapGesture)
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
}
