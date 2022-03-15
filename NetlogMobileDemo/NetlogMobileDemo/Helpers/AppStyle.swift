//
// AppStyle.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import Foundation
import UIKit

class AppStyle: NSObject {
}

extension UIColor {
    static let topSafeAreaColour = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
    static let bottomSafeAreaColour = UIColor(red: 13/255, green: 46/255, blue: 128/255, alpha: 1)
    static let navBarBGColour = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
    static let selectionViewColour = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    static let textColour = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
    static let imageViewBGColour = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.5)
    static let customBlueColour = UIColor(red: 10/255, green: 50/255, blue: 130/255, alpha: 1)
}

extension UIFont {
    static let regularRoboto12 = UIFont(name: "Roboto-Regular", size: CGFloat(12).ws)
    static let regularRoboto14 = UIFont(name: "Roboto-Regular", size: CGFloat(14).ws)
    
    static let mediumRoboto14 = UIFont(name: "Roboto-Medium", size: CGFloat(14).ws)
    static let mediumRoboto16 = UIFont(name: "Roboto-Medium", size: CGFloat(16).ws)
    
    static let boldRoboto10 = UIFont(name: "Roboto-Bold", size: CGFloat(10).ws)
    static let boldRoboto18 = UIFont(name: "Roboto-Bold", size: CGFloat(18).ws)
}
