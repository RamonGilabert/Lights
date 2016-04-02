import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  lazy var controller: LightsController = LightsController()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = controller
    window?.makeKeyAndVisible()

    Network.fetch(Request.Lights(), completion: { [weak self] JSON, error in
      guard let _ = self where error == nil else { return }
    })

    return true
  }
}
