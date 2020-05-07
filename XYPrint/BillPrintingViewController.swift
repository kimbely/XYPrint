//
//  BillPrintingViewController.swift
//  XYPrint
//
//  Created by Kimbely on 2019/12/3.
//  Copyright © 2019 Kimbely. All rights reserved.
//

import UIKit

class BillPrintingViewController: UIViewController {

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
       //        var width = 58
//        dataM.append([XYCommand.setLableWidth(width)])
//        dataM.append([XYCommand.setPrintAreaWidthWithnL(width*8%256, andnH: width*8/256)])
        
        
        dataM.append("打印测试123456789abcdefghijklnmABCDEFGHIJK".data(using: String.Encoding(rawValue: gbkEncoding))!)
        dataM.append(XYCommand.printAndFeedLine())
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
        
        let dataM = NSMutableData(data: XYCommand.initializePrinter())
        dataM.append(XYCommand.selectAlignment(1))
        dataM.append(XYCommand.setBarcoeWidth(20))
        dataM.append(XYCommand.setBarcodeHeight(20))
        
        dataM.append(XYCommand.printQRCode(4, level: 0x30, code: "xprint.com", useEnCodeing: gbkEncoding))
        dataM.append(XYCommand.printAndFeedLine())
        
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
    
    @IBAction func printBarCodeAction(_ sender: Any) {
        //****tsc
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        
        let dataM = NSMutableData(data: XYCommand.initializePrinter())
        dataM.append(XYCommand.selectHRICharactersPrintXYition(2))
        dataM.append(XYCommand.selectAlignment(1))
        dataM.append(XYCommand.setBarcodeHeight(35))
        
        dataM.append(XYCommand.printBarcode(withM: 05, andContent: "12345678", useEnCodeing: String.Encoding.ascii.rawValue))
        dataM.append(XYCommand.printAndFeedLine())
        
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
    
    @IBAction func printImageAction(_ sender: Any) {
        //****tsc
        let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        
        let dataM = NSMutableData(data: XYCommand.initializePrinter())
        if SharedAppDelegate.isConnectedWIFI ?? false{
            dataM.append(XYCommand.setTempData())
        }
        
        let data = XYCommand.printRasteBmp(withM: RasterNolmorWH, andImage: UIImage(named: ""), andType: Dithering, andPaperHeight: 1000)
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
    
    
}
extension BillPrintingViewController:XYWIFIManagerDelegate,XYBLEManagerDelegate{
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

