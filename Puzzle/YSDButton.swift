//
//  YSDButton.swift
//  GraphicsContext
//
//  Created by Youssef on 2017/6/13.
//  Copyright © 2017年 Youssef. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
}

extension UIImage {
    @objc class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    @objc class func imageFromLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return image
            }
            return UIImage.imageWithColor(UIColor(css: "fd4c5f"))
        }else {
            return UIImage.imageWithColor(UIColor(css: "fd4c5f"))
        }
    }
}

extension UIButton {
    @objc class func createHSRedButtonWith(frame: CGRect, Title title: String, Action action: @escaping (_ button: YSDButton)->()) -> UIButton {
        let image = UIImage.imageFromLayer(layer: UIColor.getLayer())
        let button = YSDButton(type: .custom)
        button.frame = frame
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(image, for: .disabled)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor(css: "e9394b")), for: .highlighted)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.action = action
        return button
    }
    
    @objc class func createHSWhiteButtonWith(frame: CGRect, Title title: String, Action action: @escaping (_ button: YSDButton)->()) -> UIButton {
        let button = YSDButton(type: .custom)
        button.frame = frame
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(css: "fd4c5f"), for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(UIColor(css: "fd4c5f").withAlphaComponent(0.5), for: .disabled)
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(UIImage.imageWithColor(UIColor(css: "fd4c5f")), for: .highlighted)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(css: "fd4c5f").cgColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.action = action
        return button
    }
    
    @objc class func createCustomButtonWith(frame: CGRect, Title title: String, TitleColor color: UIColor, Action action: @escaping (_ button: YSDButton)->()) -> UIButton {
        let button = YSDButton(type: .custom)
        button.frame = frame
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = UIColor.clear
        button.action = action
        return button
    }
}

class YSDButton: UIButton {
    var action: ((_ button: YSDButton)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(YSDButton.onButtonTap(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onButtonTap(sender: YSDButton) {
        if let ac = self.action {
            ac(sender)
        }
    }
}
