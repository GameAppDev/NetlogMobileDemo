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
import GoogleMaps
import GooglePlaces

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
        
        GMSServices.provideAPIKey("AIzaSyB5LIu9bpO5LG3tn9uyysp1N04k9YpUt6A")
        GMSPlacesClient.provideAPIKey("AIzaSyB5LIu9bpO5LG3tn9uyysp1N04k9YpUt6A")
        
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
