import UIKit

protocol StartButtonDelegate {

  func startButtonDidPress()
}

class StartButton: UIView {

  lazy var startButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(startButtonDidPress),
                     forControlEvents: .TouchUpInside)

    return button
  }()

  lazy var popView: UIView = {
    let view = UIView()
    return view
  }()

  var delegate: StartButtonDelegate?

  // MARK: - Action methods

  func startButtonDidPress() {
    delegate?.startButtonDidPress()
  }
}
