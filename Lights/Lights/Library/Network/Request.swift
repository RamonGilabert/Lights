import UIKit

protocol Requestable {

  var message: NetworkMessage { get set }
}

struct Request {

  struct Lights: Requestable {

    var message: NetworkMessage = {
      return NetworkMessage(resource: "/lights", headers: ["controller_id" : 1])
    }()
  }
}
