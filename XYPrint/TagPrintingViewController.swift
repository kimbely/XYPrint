//
//  TagPrintingViewController.swift
//  XYPrint
//
//  Created by Kimbely on 2019/12/3.
//  Copyright © 2019 Kimbely. All rights reserved.
//

import UIKit

class TagPrintingViewController: UIViewController {
    var manager = XYBLEManager.sharedInstance()
    var wifimanager = XYWIFIManager.share()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager?.delegate = self
        self.wifimanager?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.manager?.delegate = nil
        self.wifimanager?.delegate = nil
    }
    @IBAction func printTextAction(_ sender: Any) {
        let dataM = NSMutableData(data: XYCommand.initializePrinter())
        
        //****tsc
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        //    [dataM appendData:[XYCommand setLableWidth:57]];
        dataM.append(TscCommand.gapBymm(withWidth: 0, andHeight: 0))
        dataM.append(TscCommand.sizeBymm(withWidth: 70, andHeight: 25))
        dataM.append(TscCommand.cls())
        dataM.append(TscCommand.textWith(x: 10, andY: 15, andFont: "TSS24.BF2", andRotation: 0, andX_mul: 1, andY_mul: 1, andContent: "打印测试123456789abcdefghijklnmABCDEFGHIJK", usStrEnCoding: gbkEncoding))
        dataM.append(TscCommand.print(1))
        if SharedAppDelegate.isConnectedBLE ?? false {
            let data = dataM.copy() as! NSData
            manager?.xyWriteCommand(with:  Data(referencing: data))
        } else if SharedAppDelegate.isConnectedWIFI ?? false {
            let data = dataM.copy() as! NSData
            wifimanager?.xyWriteCommand(with:  Data(referencing: data))
        } else {
            ProgressHUD.showError("请连接Wi-Fi或者蓝牙")
        }
        
    }
    //打印二维码
    @IBAction func printQRCodeAction(_ sender: Any) {
        //****tsc
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        
        var dataM = Data()
        dataM.append(TscCommand.gapBymm(withWidth: 0, andHeight: 0))
        dataM.append(TscCommand.sizeBymm(withWidth: 60, andHeight: 30))
        dataM.append(TscCommand.cls())
        
        dataM.append(TscCommand.qrCodeWith(x: 3, andY: 3, andEccLevel: "H", andCellWidth: 6, andMode: "M", andRotation: 0, andContent: "www.xprint.com", usStrEnCoding: gbkEncoding))
        
        if SharedAppDelegate.isConnectedBLE ?? false {
            dataM.append(TscCommand.print(1))
            manager?.xyWriteCommand(with: dataM)
        } else if SharedAppDelegate.isConnectedWIFI ?? false {
            dataM.append(TscCommand.print(1))
            wifimanager?.xyWriteCommand(with: dataM)
        } else {
            ProgressHUD.showError("请连接Wi-Fi或者蓝牙")
        }
    }
    
    @IBAction func printBarCodeAction(_ sender: Any) {
        //****tsc
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        
        var dataM = Data()
        dataM.append(TscCommand.gapBymm(withWidth: 0, andHeight: 2))
        dataM.append(TscCommand.sizeBymm(withWidth: 70, andHeight: 30))
        dataM.append(TscCommand.cls())
        
        dataM.append(TscCommand.barcodeWith(x: 10, andY: 10, andCodeType: "128", andHeight: 40, andHunabReadable: 0, andRotation: 0, andNarrow: 2, andWide: 2, andContent: "3293829383928", usStrEnCoding: gbkEncoding))
        
        if SharedAppDelegate.isConnectedBLE ?? false {
            dataM.append(TscCommand.print(1))
            manager?.xyWriteCommand(with: dataM)
        } else if SharedAppDelegate.isConnectedWIFI ?? false {
            dataM.append(TscCommand.print(1))
            wifimanager?.xyWriteCommand(with: dataM)
        } else {
            ProgressHUD.showError("请连接Wi-Fi或者蓝牙")
        }
    }
    
    @IBAction func printImageAction(_ sender: Any) {
        //****tsc
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        
        var dataM = Data()
        dataM.append(TscCommand.gapBymm(withWidth: 0, andHeight: 0))
        dataM.append(TscCommand.sizeBymm(withWidth: 70, andHeight: 15))
        dataM.append(TscCommand.cls())
        
        dataM.append(TscCommand.bitmapWith(x: 5, andY: 5, andMode: 0, andImage: UIImage(named: ""), andBmpType: Dithering, andPaperHeight: 1000))
        if SharedAppDelegate.isConnectedBLE ?? false {
            dataM.append(TscCommand.print(1))
            manager?.xyWriteCommand(with: dataM)
        } else if SharedAppDelegate.isConnectedWIFI ?? false {
            dataM.append(TscCommand.print(1))
            wifimanager?.xyWriteCommand(with: dataM)
        } else {
            ProgressHUD.showError("请连接Wi-Fi或者蓝牙")
        }
        
    }
    
    
}
extension TagPrintingViewController:XYWIFIManagerDelegate,XYBLEManagerDelegate{
    // 成功连接主机
    func xywifiManager(_ manager: XYWIFIManager!, didConnectedToHost host: String!, port: UInt16) {
        
    }
    //斷開連接
    func xywifiManager(_ manager: XYWIFIManager!, willDisconnectWithError error: Error!) {
    }
    
    func xywifiManager(_ manager: XYWIFIManager!, didWriteDataWithTag tag: Int) {
        // 写入数据成功
    }
    
    func xywifiManager(_ manager: XYWIFIManager!, didRead data: Data!, tag: Int) {
        // 收到回传
    }
    
    func xywifiManagerDidDisconnected(_ manager: XYWIFIManager!) {
        // 断开连接
    }
    
    func xYdidUpdatePeripheralList(_ peripherals: [Any]!, rssiList: [Any]!) {
        // 发现周边
    }
    
    func xYdidConnect(_ peripheral: CBPeripheral!) {
        // 连接成功
    }
    
    func xYdidFail(toConnect peripheral: CBPeripheral!, error: Error!) {
        // 连接失败
    }
    
    func xYdidDisconnectPeripheral(_ peripheral: CBPeripheral!, isAutoDisconnect: Bool) {
        // 断开连接
    }
    
    func xYdidWriteValue(for character: CBCharacteristic!, error: Error!) {
        // 发送数据成功
    }
    
    
}

