import UIKit

class StartController: UIViewController {

  lazy var startView: StartView = { [unowned self] in
    let view = StartView()
    view.delegate = self

    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(startView)
    view.backgroundColor = UIColor.whiteColor()
  }
}

extension StartController: StartViewDelegate {

  func startButtonDidPress() {
    // TODO: Implement
  }
}
