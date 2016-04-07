import UIKit
import CoreBluetooth
import Sugar

var bluetooth = Bluetooth()

protocol BluetoothDelegate {

  func bluetoothLight()
  func shouldShowMessage(message: String)
  func showPairing()
}

protocol BluetoothPairedDelegate {

  func pairedDevice()
}

class Bluetooth: NSObject {

  struct Constants {
    static let name = "raspberrypi"
    static let peripheral = "E20A39F4-73F5-4BC4-A12F-17D1AD07A951"
    static let service = "E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
    static let characteristic = "08590F7E-DB05-467E-8757-72F6FAEB13D4"
    static let advertiser = "7DAB9750-4510-410C-B030-D5597D3EBE6D"
    static let information = [
      CBAdvertisementDataLocalNameKey : "Lights",
      CBAdvertisementDataServiceUUIDsKey : [CBUUID(string: Constants.peripheral)]
    ]
  }

  var manager: CBCentralManager?
  var peripheralManager: CBPeripheralManager?
  var characteristic: CBMutableCharacteristic?
  var service: CBMutableService?
  var light: CBPeripheral?
  var delegate: BluetoothDelegate?
  var pairedDelegate: BluetoothPairedDelegate?

  override init() {
    super.init()

    let queue = dispatch_queue_create("no.bluetooth", DISPATCH_QUEUE_SERIAL)

    manager = CBCentralManager(delegate: self, queue: queue)
    peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
  }

  func scan() {
    guard let central = manager else { return }
    central.scanForPeripheralsWithServices([CBUUID(string: Constants.service)], options: nil)
  }

  func advertise() {
    guard let central = peripheralManager else { return }
    central.startAdvertising(Constants.information)
  }
}

extension Bluetooth: CBCentralManagerDelegate {

  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    if peripheral.name == Constants.name {
      print("Lights found.") // Logs.

      manager?.stopScan()
      light = peripheral

      central.connectPeripheral(peripheral, options: nil)

      delegate?.bluetoothLight()
    }
  }

  func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
    light = peripheral

    peripheral.delegate = self
    peripheral.discoverServices([CBUUID(string: Constants.service)])
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

extension Bluetooth: CBPeripheralDelegate {

  func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
    guard let services = peripheral.services else { return }

    for service in services {
      peripheral.discoverCharacteristics([CBUUID(string: Constants.characteristic)], forService: service)
    }
  }

  func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
    guard let characteristics = service.characteristics else { return }

    for characteristic in characteristics {
      print("Characteristic found.") // Logs.

      peripheral.setNotifyValue(true, forCharacteristic: characteristic)
    }
  }

  func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
    if let data = characteristic.value,
      string = String(data: data, encoding: NSUTF8StringEncoding) {

      let controllerID = string.characters[string.endIndex.predecessor()]
      let token = string.substringToIndex(string.endIndex.predecessor())

      if let controllerID = Int(String(controllerID)) {
        Locker.controller(controllerID)
      }

      Locker.token(token)

      manager?.cancelPeripheralConnection(peripheral)
      light = nil
      manager = nil

      pairedDelegate?.pairedDevice()
    }
  }
}

extension Bluetooth: CBPeripheralManagerDelegate {

  func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
    print("Peripheral is advertising.") // Logs.
  }

  func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
    guard peripheral.state == .PoweredOn else { return }

    service = CBMutableService(type: CBUUID(string: Constants.service), primary: true)

    peripheralManager = peripheral
    characteristic = CBMutableCharacteristic(
      type: CBUUID(string: Constants.advertiser), properties: [.Read, .Write], value: nil, permissions: [.Writeable, .Readable])

    guard let service = service, characteristic = characteristic else { return }

    service.characteristics = [characteristic]
    peripheral.addService(service)

    advertise()
  }

  func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
    guard let request = requests.first else { return }

    peripheralManager?.stopAdvertising()
    delegate?.showPairing()

    if let data = request.value,
      string = String(data: data, encoding: NSUTF8StringEncoding) {

      let controllerID = string.characters[string.endIndex.predecessor()]
      let token = string.substringToIndex(string.endIndex.predecessor())

      if let controllerID = Int(String(controllerID)) {
        Locker.controller(controllerID)
      }

      Locker.token(token)

      light = nil
      manager = nil

      delay(2.5) { self.pairedDelegate?.pairedDevice() }
    }
  }
}
