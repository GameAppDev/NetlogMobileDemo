//
// RootViewController.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet var activeView: UIView!
    @IBOutlet var topSafeArea: UIView!
    @IBOutlet var bottomSafeArea: UIView!
    
    var activeNC:UINavigationController? //NC which currently on screen for Root
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        handleKeyChain()
        
        DispatchQueue.main.async {
            self.setupViews()
        }
        
        if let homeNC = appDelegate.mainStoryboard.instantiateViewController(withIdentifier: "HomeNC") as? UINavigationController {
            //Remove NC.view which is on screen
            activeNC?.view.removeFromSuperview()
            //Add new NC.view
            activeView.addSubview(homeNC.view!)
            //Set new activeNC
            activeNC = homeNC
        }
    }
    
    private func setupViews() {
        topSafeArea.backgroundColor = UIColor.topSafeAreaColour
        bottomSafeArea.backgroundColor = UIColor.bottomSafeAreaColour
    }
    
    private func handleKeyChain() {
        if let receivedData = KeyChain.load(key: "DeviceID") {
            if let result = String(data: receivedData, encoding: String.Encoding.utf8) {
                debugPrint("KeyChain DeviceID: ", result)
            }
        }
        else {
            let deviceID:String = KeyChain.createUniqueID()
            if let data = deviceID.data(using: .utf8) {
                let status = KeyChain.save(key: "DeviceID", data: data)
                debugPrint("KeyChain Status: ", status)
            }
        }
    }
}
