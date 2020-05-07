//
//  UIView+showToast.swift
//  store
//
//  Created by Marines Chin on 2019/1/16.
//  Copyright © 2019 Eason Yang. All rights reserved.
//

import UIKit

enum ShowToastSecond:Double{
    case shortTime = 1
    case longTime = 3
}

extension UIView{
    
    func showToast(text: String,_ sec: ShowToastSecond?){
        
        self.hideToast()
        let toastLb = UILabel()
        
        toastLb.numberOfLines = 0
        toastLb.lineBreakMode = .byWordWrapping
        toastLb.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLb.textColor = UIColor.white
        toastLb.layer.cornerRadius = 10.0
        toastLb.textAlignment = .center
        toastLb.font = UIFont.systemFont(ofSize: 15.0)
        toastLb.text = text
        toastLb.layer.masksToBounds = true
        toastLb.tag = 9999//tag：hideToast實用來判斷要remove哪個label
        
        let maxSize = CGSize(width: self.bounds.width - 40, height: self.bounds.height)
        var expectedSize = toastLb.sizeThatFits(maxSize)
        var lbWidth = maxSize.width
        var lbHeight = maxSize.height
        if maxSize.width >= expectedSize.width{
            lbWidth = expectedSize.width
        }
        if maxSize.height >= expectedSize.height{
            lbHeight = expectedSize.height
        }
        expectedSize = CGSize(width: lbWidth, height: lbHeight)
        toastLb.frame = CGRect(x: ((self.bounds.size.width)/2) - ((expectedSize.width + 20)/2), y: 80, width: expectedSize.width + 20, height: expectedSize.height + 20)
        self.addSubview(toastLb)
        
        UIView.animate(withDuration: 2, delay: sec?.rawValue ?? 1, animations: {
            toastLb.alpha = 0.0
        }) { (complete) in
            toastLb.removeFromSuperview()
        }
    }
    
    func hideToast(){
        for view in self.subviews{
            if view is UILabel , view.tag == 9999{
                view.removeFromSuperview()
            }
        }
    }
    
    func aspectRation(_ ratio: CGFloat) -> NSLayoutConstraint {
        
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}
//匡線設定
extension UIView {
    
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }}

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }}
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }}
    
    @IBInspectable var shadowWidth: CGFloat {
        get {
            return layer.shadowOffset.width
        }
        set {
            layer.shadowOffset.width = newValue
        }}
    @IBInspectable var shadowHight: CGFloat {
        get {
            return layer.shadowOffset.height
        }
        set {
            layer.shadowOffset.height = newValue
        }}
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue!.cgColor
        }
    }
    
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
extension UIView {
    
    func image () -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
extension UIView
{
    func copyView() -> UIView?
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
}
