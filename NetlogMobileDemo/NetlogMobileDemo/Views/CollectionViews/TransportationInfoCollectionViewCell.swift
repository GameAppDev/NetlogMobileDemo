//
// TransportationInfoCollectionViewCell.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit

class TransportationInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    let identifierTransportationInfoCVC:String = "TransportationInfoCollViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.regularRoboto12
        titleLabel.textColor = UIColor.textColour
        
        infoLabel.font = UIFont.mediumRoboto14
        infoLabel.textColor = UIColor.textColour
    }
}
