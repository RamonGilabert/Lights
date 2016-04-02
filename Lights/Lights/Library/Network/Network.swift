import UIKit
import Sugar
import SocketIOClientSwift

struct Network {

  static var session = NSURLSession.sharedSession()

  static func fetch(request: Requestable, completion: (JSON: JSONArray, error: NSError?) -> ()) {
    process(request.message, .GET, completion)
  }

  static func socket() {
    // TODO: Implement the sockets.
  }

  static func process(message: NetworkMessage, _ method: Request.Method, _ completion: (JSON: JSONArray, error: NSError?) -> ()) {
    let request = NSMutableURLRequest()
    request.URL = message.URL
    request.HTTPMethod = method.rawValue
    request.allHTTPHeaderFields = message.headers

    let task = session.dataTaskWithRequest(request) { data, response, error in
      guard let response = response as? NSHTTPURLResponse else { completion(JSON: [], error: error); return }

      guard let data = data where error == nil && API.OK.contains(response.statusCode)
        else { completion(JSON: [], error: error); return }

      do {
        guard let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray
          else { completion(JSON: [], error: error); return }

        completion(JSON: JSON, error: error)
      } catch {
        print("There was an error with your request.")
      }

      completion(JSON: [], error: error)
    }

    task.resume()
  }
}
