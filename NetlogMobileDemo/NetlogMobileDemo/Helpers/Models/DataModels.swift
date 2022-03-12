//
// DataModels.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import Foundation
import CoreLocation

struct Address:Codable {
    let lat:Double?
    let lng:Double?
}

struct User {
    var location2D:CLLocationCoordinate2D?
    var geoLocatedAddress:String?
}
