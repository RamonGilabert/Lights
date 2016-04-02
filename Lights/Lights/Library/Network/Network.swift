import UIKit
import Sugar
import SocketIOClientSwift

struct Network {

  static func fetch<T : Requestable>(request: T, completion: (response: [String : AnyObject], error: NSError)) {
    process(request, completion: completion)
  }

  static func socket() {
    // TODO: Implement the sockets.
  }

  static func process<T : Requestable>(request: T, completion: (response: [String : AnyObject], error: NSError)) {
    
  }
}
