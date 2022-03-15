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
import UIKit

struct Address:Codable {
    let lat:Double?
    let lng:Double?
}

struct User {
    var location2D:CLLocationCoordinate2D?
    var geoLocatedAddress:String?
}

struct TransportationInfoResponse:Codable {
    let title:String?
    let info:String?
}

struct Image {
    var data:Data?
    var type:String?
}

struct TabImage {
    var imageKey:String?
    var isSelected:Bool = false
}
