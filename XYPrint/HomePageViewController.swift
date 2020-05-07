//
//  HomePageViewController.swift
//  XYPrint
//
//  Created by Kimbely on 2019/12/3.
//  Copyright © 2019 Kimbely. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    var XYBLEmanager = XYBLEManager.sharedInstance()
    var XYWifimanager = XYWIFIManager.share()
    
    
    @IBOutlet weak var statusBtn: UIBarButtonItem!
    @IBOutlet weak var ipAdress: UITextField!
    func dealloc() {
        XYBLEmanager?.removeObserver(self, forKeyPath: "writePeripheral.state", context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "未連接"
        NotificationCenter.default.addObserver(self, selector: #selector(connectBle(text:)), name: NSNotification.Name(rawValue: "ConnectBleSuccessNote"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.XYBLEmanager?.delegate = self
        self.XYWifimanager?.delegate = self
        self.XYBLEmanager?.addObserver(self, forKeyPath: "writePeripheral.state", options: [.new,.old], context: nil)
    }
    
    @objc func connectBle(text: Notification) {
        statusBtn.title = "斷開連接"
        SharedAppDelegate.isConnectedBLE = true
        SharedAppDelegate.isConnectedWIFI = false
    }

    @IBAction func coonect(_ sender: Any) {
        if ipAdress.text == ""{
            ProgressHUD.showError("請輸入IP位置")
            return
        }
        
        self.XYWifimanager?.xyDisConnect()
        ProgressHUD.show("正在連接")
        self.XYWifimanager?.xyConnect(withHost: ipAdress.text, port: UInt16(Int("9100") ?? 0)) { (isConnect) in
            print(isConnect)
        }
        
    }
    @IBAction func connectBleAction(_ sender: Any) {
        
//        let vc = SelectionDeviceVC.controller()
//        vc?.callBack = { x in
//            SharedAppDelegate.isConnectedBLE = true
//            SharedAppDelegate.isConnectedWIFI = false
//            self.statusBtn.setTitle("断开连接", for: .normal)
//            let message = "蓝牙连接成功"
//            self.view.makeToast(message, duration: 2, xYition: CSToastXYitionCenter)
//        }
//        if let vc = vc {
//            navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        view.endEditing(true)
    }
    
    @IBAction func disConnectAction(_ sender: Any) {
        if !(SharedAppDelegate.isConnectedWIFI ?? false) && !(SharedAppDelegate.isConnectedBLE ?? false){
            return
        }
        if SharedAppDelegate.isConnectedWIFI ?? false {
            XYWifimanager?.xyDisConnect()
        }
        if SharedAppDelegate.isConnectedBLE ?? false {
            XYBLEmanager?.xYdisconnectRootPeripheral()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? XYBLEManager == XYBLEmanager && (keyPath == "writePeripheral.state") {
            // 更行蓝牙的连接状态
            switch XYBLEmanager!.writePeripheral.state {
            case CBPeripheralState.disconnected:
                statusBtn.title = "未连接"
                SharedAppDelegate.isConnectedBLE = false
            case CBPeripheralState.connecting:
                statusBtn.title = "设备正在连接"
            case CBPeripheralState.connected:
                statusBtn.title = "已连接"
                SharedAppDelegate.isConnectedBLE = true
            case CBPeripheralState.disconnecting:
                statusBtn.title = "未连接"
                SharedAppDelegate.isConnectedBLE = false
            default:
                break
            }
        }
    }


}
extension HomePageViewController:XYWIFIManagerDelegate,XYBLEManagerDelegate{
    // 成功连接主机
    func xywifiManager(_ manager: XYWIFIManager!, didConnectedToHost host: String!, port: UInt16) {
        ProgressHUD.dismiss()
        SharedAppDelegate.isConnectedWIFI = true
        SharedAppDelegate.isConnectedBLE = false
        self.statusBtn.title = "斷開連接"
        self.view.showToast(text: "WI-FI連接成功", .shortTime)
    }
    //斷開連接
    func xywifiManager(_ manager: XYWIFIManager!, willDisconnectWithError error: Error!) {
        // 是自动断开连接 还是 手动断开
        if !manager.isAutoDisconnect{
            print("手動斷開")
        }
        self.statusBtn.title = "未連接"
        SharedAppDelegate.isConnectedWIFI = false
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
