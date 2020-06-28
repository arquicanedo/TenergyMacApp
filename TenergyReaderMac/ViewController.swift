//
//  ViewController.swift
//  TenergyReaderMac
//
//  Created by Arquimedes Canedo on 6/25/20.
//  Copyright © 2020 Arquimedes Canedo. All rights reserved.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, CBPeripheralDelegate, CBCentralManagerDelegate {



    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    
    /*
     15:00:00.6020: discovered characteristics for service FFF0: (
         FFF1,
         FFF2,
         FFF3,
         FFF4,
         FFF5
     )
     
     Probe 6
     
     15:00:00.6020: state changed to 'Connected'.
     15:00:00.8040: received update from characteristic 2A23___180A: <4108c300 00730478>
     15:00:00.8260: received update from characteristic 2A24___180A: <69424251>
     15:00:00.8490: received update from characteristic 2A25___180A: <30302d30 30303030 30>
     15:00:00.8710: received update from characteristic 2A26___180A: <332e3130 2e32>
     15:00:00.9050: received update from characteristic 2A27___180A: <332e3130 2e32>
     15:00:00.9500: received update from characteristic 2A28___180A: <332e3130 2e32>
     15:00:00.9720: received update from characteristic 2A29___180A: <51696c69 6e206e65 74>
     15:00:01.0060: received update from characteristic 2A2A___180A: <fe006578 70657269 6d656e74 616c>
     15:00:01.0850: received update from characteristic 2A50___180A: <010d0000 001001>
     15:00:01.1300: received update from characteristic 2A23___180A: <4108c300 00730478>
     15:00:01.1520: received update from characteristic 2A24___180A: <69424251>
     15:00:01.1750: received update from characteristic 2A25___180A: <30302d30 30303030 30>
     15:00:01.1970: received update from characteristic 2A26___180A: <332e3130 2e32>
     15:00:01.2200: received update from characteristic 2A27___180A: <332e3130 2e32>
     15:00:01.2540: received update from characteristic 2A28___180A: <332e3130 2e32>
     15:00:01.2760: received update from characteristic 2A29___180A: <51696c69 6e206e65 74>
     15:00:01.3100: received update from characteristic 2A2A___180A: <fe006578 70657269 6d656e74 616c>
     15:00:01.3320: received update from characteristic 2A50___180A: <010d0000 001001>
     15:00:01.3550: received update from characteristic 2A23___180A: <4108c300 00730478>
     15:00:01.3770: received update from characteristic 2A24___180A: <69424251>
     15:00:01.4000: received update from characteristic 2A25___180A: <30302d30 30303030 30>
     15:00:01.4680: received update from characteristic 2A26___180A: <332e3130 2e32>
     15:00:01.4900: received update from characteristic 2A27___180A: <332e3130 2e32>
     15:00:01.5120: received update from characteristic 2A28___180A: <332e3130 2e32>
     15:00:01.5460: received update from characteristic 2A29___180A: <51696c69 6e206e65 74>
     15:00:01.5690: received update from characteristic 2A2A___180A: <fe006578 70657269 6d656e74 616c>
     15:00:01.6020: received update from characteristic 2A50___180A: <010d0000 001001>
     15:00:01.6250: received update from characteristic 2A23___180A: <4108c300 00730478>
     15:00:01.6470: received update from characteristic 2A24___180A: <69424251>
     15:00:01.6700: received update from characteristic 2A25___180A: <30302d30 30303030 30>
     15:00:01.7040: received update from characteristic 2A26___180A: <332e3130 2e32>
     15:00:01.7370: received update from characteristic 2A27___180A: <332e3130 2e32>
     15:00:01.7600: received update from characteristic 2A28___180A: <332e3130 2e32>
     15:00:01.7830: received update from characteristic 2A29___180A: <51696c69 6e206e65 74>
     15:00:01.8050: received update from characteristic 2A2A___180A: <fe006578 70657269 6d656e74 616c>
     15:00:01.8270: received update from characteristic 2A50___180A: <010d0000 001001>
     
     */
    
    //public static let TenergyUUID = CBUUID.init(string: "FFF0")  // Temperature

    public static let TenergyUUID = CBUUID.init(string: "FFF0")  // Tenergy Service
    public static let TenergyTempCharacteristic = CBUUID.init(string: "FFF4")   // Temperature Characteristic
    public static let TenergyPairingCharacteristic = CBUUID.init(string: "FFF2")  // Pairing Characteristic
    public static let TenergyCommandCharacteristic = CBUUID.init(string: "FFF5")  // Command Characteristic
    public static let TenergyTempDescriptor = CBUUID.init(string: "2902")
    //public static let Tenergy_AUTO_PAIR_BYTES: [UInt8] = [33,7,6,5,4,3,2,1,-72,34,0,0,0,0,0]
    //public static let Tenergy_AUTO_PAIR_KEY = Data.init(_: ViewController.Tenergy_AUTO_PAIR_BYTES)
    
    public static let TenergySignedBytes: [Int16] = [33,7,6,5,4,3,2,1,-72,34,0,0,0,0,0];

    
    private var tempCharacteristic: CBCharacteristic?
    private var pairingCharacteristic: CBCharacteristic?
    private var commandCharacteristic: CBCharacteristic?
    
    //public static let TenergyUUID = CBUUID.init(string: "0000FFF0-0000-1000-8000-00805F9B34FB")  // Temperature
    //public static let TenergyPairingCharacteristic = CBUUID.init(string: "0000FFF2-0000-1000-8000-00805F9B34FB")  // Pairing
    //public static let TenergyCommandCharacteristic = CBUUID.init(string: "0000FFF5-0000-1000-8000-00805F9B34FB")  // Pairing


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ViewController viewDidLoad()")
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
           var consoleLog = ""

           switch central.state {
               case .poweredOff:
                   consoleLog = "BLE is powered off"
               case .poweredOn:
                   consoleLog = "BLE is poweredOn"
               case .resetting:
                   consoleLog = "BLE is resetting"
               case .unauthorized:
                   consoleLog = "BLE is unauthorized"
               case .unknown:
                   consoleLog = "BLE is unknown"
               case .unsupported:
                   consoleLog = "BLE is unsupported"
               default:
                   consoleLog = "default"
           }
        print(consoleLog)
        
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning from centralManagerDidUpdateState for...", ViewController.TenergyUUID)
            centralManager.scanForPeripherals(withServices: [ViewController.TenergyUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We've found it so stop scan
        print("We've found it so stop scan")
        self.centralManager.stopScan()
        
        print("Copying the peripheral instance")
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        print("Connecting to peripheral", self.peripheral.name, self.peripheral.identifier)

        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
        
        
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to peripheral", peripheral.name)
            peripheral.discoverServices([ViewController.TenergyUUID]);
        }
    }
    
    // If disconnected reconnects
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            print("Disconnected")
            self.peripheral = nil
            
            // Start scanning again
            print("Central scanning from centralManager for ...");
            centralManager.scanForPeripherals(withServices: [ViewController.TenergyUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("peripheral discovery event handler")
        if let services = peripheral.services {
            print("services exist", services)
            for service in services {
                print("service found", service.uuid)
                if service.uuid == ViewController.TenergyUUID {
                    print("Tenergy service found", service.uuid)
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([ViewController.TenergyTempCharacteristic, ViewController.TenergyPairingCharacteristic, ViewController.TenergyCommandCharacteristic], for: service)
                }
                else {
                    print("Other service found", service.uuid)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateNotificationStateFor characteristic: CBCharacteristic,
                     error: Error?) {
        print("peripheral Enabling notify ", characteristic.uuid, characteristic)
        if error != nil {
            print("peripheral Enable notify error")
        }
    }


    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Printing characteristics...")

        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print(characteristic)
                if characteristic.uuid == ViewController.TenergyTempCharacteristic {
                    print("Temp characteristic found, setting notification")
                    tempCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                    //peripheral.discoverDescriptors(for: characteristic)
                }
                if characteristic.uuid == ViewController.TenergyPairingCharacteristic {
                    print("Pairing characteristic found, writing AUTO_PAIR_KEY")
                    
                    var TenergyUnsignedBytes: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
                    for (i, _) in TenergyUnsignedBytes.enumerated() {
                        TenergyUnsignedBytes[i] |= UInt8(ViewController.TenergySignedBytes[i] & 0xFF)
                    }
                    let Tenergy_AUTO_PAIR_KEY = Data(TenergyUnsignedBytes)
                    peripheral.writeValue(Tenergy_AUTO_PAIR_KEY, for: characteristic, type: .withoutResponse)
                    
                }
                if characteristic.uuid == ViewController.TenergyCommandCharacteristic {
                    print("Command characteristic found, writing bytes")
                    let CommandBytes = Data([11, 1, 0, 0, 0, 0])
                    peripheral.writeValue(CommandBytes, for: characteristic, type: .withResponse)
                }
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateValueFor characteristic: CBCharacteristic,
                     error: Error?) {

        /*
        let tempC = [
            characteristic.value![0],
            characteristic.value![1],
            characteristic.value![2],
            characteristic.value![3],
            characteristic.value![4],
            characteristic.value![5],
            characteristic.value![6],
            characteristic.value![7],
            characteristic.value![8],
            characteristic.value![9],
            characteristic.value![10],
            characteristic.value![11]
            ]
        */
        
        // https://www.cocoaphile.com/posts/turning-data-into-numbers-in-swift
        let probes = [
            characteristic.value![0...1],
            characteristic.value![2...3],
            characteristic.value![4...5],
            characteristic.value![6...7],
            characteristic.value![8...9],
            characteristic.value![10...11]
        ]

        var temps = [Int16](repeating:0, count:6)
        for (i, _) in temps.enumerated() {
            temps[i] = probes[i].withUnsafeBytes { (pointer: UnsafePointer<Int16>) -> Int16 in return pointer.pointee }
            temps[i] /= 10
        }
        

        print("Celcius:", temps)
        
    }
    
    /*
    // Handle the discovery of descriptors
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?)
    {
        if let descriptors = characteristic.descriptors {
            for descriptor in descriptors {
                print("Descriptor value = ", descriptor.value)
            }
        }
    }
    */
}

