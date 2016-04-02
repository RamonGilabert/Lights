import UIKit

struct NetworkMessage {

  struct Constants {
    static let contentType = "Content-Type"
    static let application = "application/json"
  }

  var resource: String = ""
  var headers: [String : String] = [:]
  var URL: NSURL?

  init(resource: String, headers: [String : String]) {
    self.resource = resource
    self.headers = headers
    self.URL = nil

    prepare()
  }

  mutating func prepare() {
    headers[Constants.contentType] = Constants.application
    URL = NSURL(string: API.route + resource)
  }
}
