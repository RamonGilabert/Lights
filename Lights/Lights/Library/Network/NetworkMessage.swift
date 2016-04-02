import UIKit

struct NetworkMessage {

  struct Constants {
    static let contentType = "Content-Type"
    static let application = "application/json"
  }

  var resource: String = ""
  var headers: [String : AnyObject] = [:]

  init(resource: String, headers: [String : AnyObject]) {
    self.resource = resource
    self.headers = headers

    prepare()
  }

  mutating func prepare() {
    headers[Constants.contentType] = Constants.application
  }
}
