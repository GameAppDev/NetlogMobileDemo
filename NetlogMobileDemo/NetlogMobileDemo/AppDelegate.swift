//
// AppDelegate.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit

let appMode = "test" // test or live
let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var mainStoryboard:UIStoryboard!
    var rootVC:RootViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let lang = Locale.current.languageCode
        UserDefaults.standard.set(lang, forKey: "LANG")
        
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        openRoot()
        
        return true
    }
    
    private func openRoot() {
        rootVC = mainStoryboard.instantiateViewController(withIdentifier: "RootVC") as? RootViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}
