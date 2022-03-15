//
// Extensions.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit
import Foundation

extension UITableView {
    
    func registerCell(identifier:String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        self.tableFooterView = UIView()
        self.rowHeight = UITableView.automaticDimension
        //self.estimatedRowHeight = 100.0
        self.separatorStyle = .none
    }
}

extension UICollectionView {
    
    func registerCell(nibName:String, identifier:String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}

extension UIViewController {
    
    func showAlert(with message:String, title:String, yesButtonText:String, noButtonText:String?, yesTapped:(()->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: yesButtonText, style: .default) { (_) in
            yesTapped?()
        }
        if let cancelText = noButtonText {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String?, message: String?, action1Title: String?, action1Handler: ((UIAlertAction) -> Swift.Void)? = nil, action2Title: String?, action2Handler: ((UIAlertAction) -> Swift.Void)? = nil) {

        let alertContr = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        if let action1Title = action1Title {
            let action1 = UIAlertAction(title: action1Title, style: .default, handler: action1Handler)
            alertContr.addAction(action1)
        }
        if let action2Title = action2Title {
            let action2 = UIAlertAction(title: action2Title, style: .default, handler: action2Handler)
            alertContr.addAction(action2)
        }
        alertContr.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alertContr, animated: true, completion: nil)
    }
}

extension CGFloat {
    
    var ws: CGFloat { //Change 320 with your View Width
        return (self / 320) * UIScreen.main.bounds.width
    }
    var hs: CGFloat {
        return (self / 568) * UIScreen.main.bounds.height
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius.ws }
        set {
            layer.cornerRadius = newValue.ws
            layer.masksToBounds = newValue.ws > 0
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension String {
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"
        if let theDate = dateFormatter.date(from:self) {
            return theDate
        }
        let currentDate = Date()
        return currentDate
    }
}

extension Date {
    
    func toString(formatType: String ) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = formatType
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
}
