//
// ServiceManager.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import Foundation
import GoogleMaps

class ServiceManager {
    
    static let shared = ServiceManager()
    
    let baseUrl:String = ""
    
    typealias tokenHandler = (_ request:URLRequest?, Bool) -> Void
    
    func getAddressDetail(coordinate:CLLocationCoordinate2D, handler: @escaping ((String?, String, Bool) -> Void)) {
        let errorCode = "1000"
        
        GMSGeocoder().reverseGeocodeCoordinate(coordinate) { response , error in
            if let responseError = error {
                handler(responseError.localizedDescription, errorCode, false)
                return
            }
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]

                let currentAddress = lines.joined(separator: "\n")
                handler(currentAddress, errorCode, true)
                return
            }
            handler("No address response", errorCode, false)
            return
        }
    }
}
