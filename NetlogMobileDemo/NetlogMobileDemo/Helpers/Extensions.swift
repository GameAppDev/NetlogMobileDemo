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

extension UIViewController {
    
    func showAlert(with mesaj:String, title:String? = "") {
        DispatchQueue.main.async(execute: {
            let app = UIApplication.shared.delegate as! AppDelegate
            let rootVC = app.window!.rootViewController as! RootViewController

            let alertCtrl = UIAlertController(title: title, message: mesaj, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertCtrl.addAction(action)
            
            rootVC.present(alertCtrl, animated: true, completion: nil)
        })
    }
    
    func showPopupWith2Buttons(with message:String, title:String, yesButtonText:String, noButtonText:String, yesTapped:(()->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: yesButtonText, style: .default) { (_) in
            yesTapped?()
        }
        let cancelAction = UIAlertAction(title: noButtonText, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
