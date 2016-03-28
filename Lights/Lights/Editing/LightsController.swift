import UIKit
import Transition
import Walker

class LightsController: UIViewController {

  lazy var searchButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: Image.search)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
    button.tintColor = Color.General.life

    return button
  }()

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      guard let controller = controller as? LightsController else { return }

      controller.view.alpha = 1
    }

    transition.spring = (0.6, 0.4)
    transition.animationDuration = 1

    return transition
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = transition

    view.backgroundColor = UIColor.blackColor()
  }
}
