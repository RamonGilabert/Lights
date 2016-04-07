import UIKit

protocol Requestable {

  var message: NetworkMessage { get set }
}

struct Request {

  enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
  }

  struct Lights: Requestable {
    var message: NetworkMessage = {
      return NetworkMessage(resource: "/lights", headers: ["controller_id" : "\(Locker.controller())"])
    }()
  }
}
