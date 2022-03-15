//
// TabItemCollectionViewCell.swift
// NetlogMobileDemo
//
// Created on 14.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit

class TabItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var tabImageView: UIImageView!
    @IBOutlet var seperatorView: UIView!
    
    let identifierTabItemCVC:String = "TabItemCollViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seperatorView.backgroundColor = UIColor.black
    }
}
