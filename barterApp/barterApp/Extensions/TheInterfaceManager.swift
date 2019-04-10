//
//  TheInterfaceManager.swift
//  barterApp
//
//  Created by Kevin Maldjian on 4/8/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import Foundation
import UIKit

let TheInterfaceManager = InterfaceManager.sharedInstance
let rootViewController =  UIApplication.shared.keyWindow?.rootViewController

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UITableView {
    func setOffsetToBottom(_ animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }
    
    func scrollToLastRow(_ animated: Bool) {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: animated)
        }
    }
}

extension UIImage {
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(Double.pi))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func fixImageOrientation() -> UIImage
    {
        
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi));
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0);
            transform = transform.rotated(by: CGFloat(Double.pi / 2));
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2));
            
        case .up, .upMirrored:
            break
        }
        
        
        switch self.imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1);
            
        default:
            break;
        }
        
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(
            data: nil,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: self.cgImage!.bitsPerComponent,
            bytesPerRow: 0,
            space: self.cgImage!.colorSpace!,
            bitmapInfo: UInt32(self.cgImage!.bitmapInfo.rawValue)
        )
        
        ctx!.concatenate(transform);
        
        switch self.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx!.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height,height: self.size.width));
            
        default:
            ctx!.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width,height: self.size.height));
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx!.makeImage()
        
        let img = UIImage(cgImage: cgimg!)
        
        //CGContextRelease(ctx);
        //CGImageRelease(cgimg);
        
        return img;
        
    }
}

extension UIImageView {
    func downloadedFrom(link:String, indicatorStyle: UIActivityIndicatorView.Style, contentMode mode: UIView.ContentMode) {
        guard
            let url = URL(string: link)
            else {return}
        contentMode = mode
        let loadingActivity = UIActivityIndicatorView(style: indicatorStyle)
        loadingActivity.tag = 10
        loadingActivity.frame = self.bounds
        self.addSubview(loadingActivity)
        loadingActivity.startAnimating()
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else
            {
                loadingActivity.stopAnimating()
                loadingActivity.removeFromSuperview()
                return
            }
            DispatchQueue.main.async { () -> Void in
                loadingActivity.stopAnimating()
                loadingActivity.removeFromSuperview()
                self.image = image
            }
        }).resume()
    }
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate//Your app delegate class name.
extension UIApplication {
    class func topViewController(_ base: UIViewController? = appDelegate.window!.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

class InterfaceManager: NSObject, UIAlertViewDelegate {
    static let sharedInstance = InterfaceManager()
    var appName:String = ""
    
    var mainTabViewCon: TabViewController? = nil
    // var scheduleOrdersViewCon: ScheduledOrdersViewController? = nil
    
    var bTappedMenu: Bool = false
    
    var fTabBarHeight: CGFloat = 0.0
    
    let mainColor:UIColor = UIColor(red: 77.0/255.0, green: 181.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    let borderColor:UIColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
    let naviTintColor:UIColor = UIColor(red: 252.0/255.0, green: 110.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    
    override init() {
        super.init()
        let bundleInfoDict: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        appName = bundleInfoDict["CFBundleName"] as! String
    }
    
    func deviceHeight ()-> CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    func deviceWidth () -> CGFloat{
        return UIScreen.main.bounds.size.width
    }
    
    func checkiPhoneX() -> Bool {
        var bRet: Bool = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5/5s/5c/5e")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X")
                bRet = true
            default:
                print("unknown")
            }
        }
        
        return bRet
    }
    
    func checkiPhone4() -> Bool {
        var bRet: Bool = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                bRet = true
            case 1136:
                print("iPhone 5/5s/5c/5e")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X")
            default:
                print("unknown")
            }
        }
        
        return bRet
    }
    
    func checkNoteShow() -> Bool {
        let bRet = UserDefaults.standard.bool(forKey: "note_show")
        return !bRet
    }
    
    func updateShowNoteSection() {
        UserDefaults.standard.set(true, forKey: "note_show")
        UserDefaults.standard.synchronize()
    }
    
    static func doPopUpAnimation (_ view: UIView, needAlpha: Bool, completion: @escaping () -> Void) {
        if view.isHidden == true {
            view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6);
        }
        
        view.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            view.alpha = 0.8
        },
                       completion: {(bCompleted) -> Void in
                        UIView.animate(withDuration: 1/15.0, animations: {() -> Void in
                            view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            view.alpha = 0.9
                        },
                                       completion: {(bCompleted) -> Void in
                                        UIView.animate(withDuration: 1/7.5, animations: {() -> Void in
                                            view.transform = CGAffineTransform.identity
                                            view.alpha = 1.0
                                            if (needAlpha) {
                                                view.alpha = 0.3
                                            }
                                        },
                                                       completion: {(bCompleted) -> Void in
                                                        if (bCompleted) {
                                                            completion()
                                                        }
                                        })
                        })
                        
        })
    }
    
    static func scaleImage(_ image: UIImage, toSize newSize: CGSize) -> (UIImage) {
        let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context!.concatenate(flipVertical)
        context!.draw(image.cgImage!, in: newRect)
        let newImage = UIImage(cgImage: context!.makeImage()!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func imageWithColor(_ color:UIColor) -> UIImage {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    static func makeRadiusControl(_ view:UIView, cornerRadius radius:CGFloat, withColor borderColor:UIColor, borderSize borderWidth:CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.layer.masksToBounds = true
    }
    
    static func addShadowToView(_ view: UIView, _ shadow_color: UIColor, _ offset: CGSize, _ shadow_radius: CGFloat, _ corner_radius: CGFloat) {
        view.layer.shadowColor = shadow_color.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = shadow_radius
        view.layer.cornerRadius = corner_radius
    }
    
    static func addShadowToViewWithBorder(_ view: UIView, _ shadow_color: UIColor, _ offset: CGSize, _ shadow_radius: CGFloat, _ corner_radius: CGFloat, _ border_color: UIColor, _ border_width: CGFloat = 1.0) {
        view.layer.shadowColor = shadow_color.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = shadow_radius
        view.layer.cornerRadius = corner_radius
        view.layer.borderColor = border_color.cgColor
        view.layer.borderWidth = border_width
    }
    
    static func addBorderToView(_ view:UIView, toCorner corner:UIRectCorner, cornerRadius radius:CGSize, withColor borderColor:UIColor, borderSize borderWidth:CGFloat) {
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radius)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path  = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = view.bounds
        borderLayer.path  = maskPath.cgPath
        borderLayer.lineWidth   = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor   = UIColor.clear.cgColor
        borderLayer.setValue("border", forKey: "name")
        
        if let sublayers = view.layer.sublayers {
            for prevLayer in sublayers {
                if let name: AnyObject = prevLayer.value(forKey: "name") as AnyObject {
                    if name as! String == "border" {
                        prevLayer.removeFromSuperlayer()
                    }
                }
            }
        }
        
        view.layer.addSublayer(borderLayer)
    }
}
