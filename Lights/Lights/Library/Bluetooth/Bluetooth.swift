import UIKit
import CoreBluetooth
import Sugar

var bluetooth = Bluetooth()

protocol BluetoothDelegate {

  func bluetoothLight()
  func shouldShowMessage(message: String)
}

protocol BluetoothPairedDelegate {

  func pairedDevice(token: String, controllerID: String)
}

class Bluetooth: NSObject {

  struct Constants {
    static let name = "raspberrypi"
  }

  var manager: CBCentralManager?
  var light: CBPeripheral?
  var delegate: BluetoothDelegate?
  var pairedDelegate: BluetoothPairedDelegate?

  override init() {
    super.init()

    let queue = dispatch_queue_create("no.bluetooth", DISPATCH_QUEUE_SERIAL)
    manager = CBCentralManager(delegate: self, queue: queue)
  }

  func scan() {
    guard let central = manager else { return }
    central.scanForPeripheralsWithServices(nil, options: nil)
  }
}

extension Bluetooth: CBCentralManagerDelegate {

  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    if peripheral.name == Constants.name {
      print("Found")
      light = peripheral
      central.connectPeripheral(peripheral, options: nil)

      delegate?.bluetoothLight()
    }
  }

  func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
    pairedDelegate?.pairedDevice("", controllerID: "1")
    manager?.stopScan()
  }

  func centralManagerDidUpdateState(central: CBCentralManager) {
    var message = ""

    switch central.state {
    case .Unauthorized:
      message = Text.Bluetooth.unauthorized
    case .PoweredOff:
      message = Text.Bluetooth.powered
    case .PoweredOn:
      scan(); return
    default:
      message = Text.Bluetooth.unknown
    }

    delegate?.shouldShowMessage(message)
  }
}
