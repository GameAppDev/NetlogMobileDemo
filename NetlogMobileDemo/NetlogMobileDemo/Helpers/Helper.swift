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
}
