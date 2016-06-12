import UIKit
import Sugar
import SocketIOClientSwift

struct Network {

  static var session = NSURLSession.sharedSession()

  static func fetch(request: Requestable, completion: (JSON: JSONArray, error: NSError?) -> ()) {
    process(request.message, .GET, completion)
  }

  static func process(message: NetworkMessage, _ method: Request.Method, _ completion: (JSON: JSONArray, error: NSError?) -> ()) {
    let request = NSMutableURLRequest()
    request.URL = message.URL
    request.HTTPMethod = method.rawValue
    request.allHTTPHeaderFields = message.headers

    let task = session.dataTaskWithRequest(request) { data, response, error in
      dispatch {
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
    }

    task.resume()
  }
}

struct Socket {

  static var socket: SocketIOClient? = {
    guard let URL = NSURL(string: API.route) else { return nil }

    return SocketIOClient(socketURL: URL, options: [.Log(true), .ForcePolling(true)])
  }()


  static func connect() {
    guard let socket = socket else { return }

    handle()

    socket.connect()
  }

  static func disconnect() {
    guard let socket = socket else { return }
    socket.disconnect()
  }

  static func handle() {
    guard let socket = socket else { return }

    socket.on("connect") { data, error in
      print("Socket connected")
    }
  }

  static func change(completion: (() -> ())? = nil) {
    guard let socket = socket, light = Locker.light() else { return }

    socket.emit(API.socket, [
      Locker.Key.id : light.id,
      Locker.Key.status : light.status,
      Locker.Key.intensity : light.intensity,
      Locker.Key.red : light.red,
      Locker.Key.green : light.green,
      Locker.Key.blue : light.blue,
      Locker.Key.controllerID : light.controllerID,
      Locker.Key.token : Locker.token()
      ])
  }
}
