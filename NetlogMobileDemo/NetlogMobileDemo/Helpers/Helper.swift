//
// Helper.swift
// NetlogMobileDemo
//
// Created on 15.03.2022.
// Oguzhan Yalcin
//
//
//


import Foundation
import UIKit

struct Helper {
    
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func setDeviceIDtoKeyChain() {
        if KeyChain.load(key: "DeviceID") == nil {
            let deviceID:String = KeyChain.createUniqueID()
            if let data = deviceID.data(using: .utf8) {
                let status = KeyChain.save(key: "DeviceID", data: data)
                debugPrint("KeyChain Status: ", status)
            }
        }
    }
    
    static func getDeviceIDfromKeyChain() -> String {
        var deviceID = "Unknown"
        if let receivedData = KeyChain.load(key: "DeviceID") {
            if let result = String(data: receivedData, encoding: String.Encoding.utf8) {
                deviceID = result
            }
        }
        
        return deviceID
    }
}
