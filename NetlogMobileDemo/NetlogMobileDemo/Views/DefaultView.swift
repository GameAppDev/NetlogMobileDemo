//
// DefaultView.swift
// NetlogMobileDemo
//
// Created on 16.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit

enum SelectionStatus:String {
    case selection1
    case selection3
    case selection5
    case none
}

class DefaultView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet var infoLabel: UILabel!
    
    var status:SelectionStatus = .none
    var text:String = ""
    
    convenience init(frame: CGRect, viewStatus:SelectionStatus, viewText:String) {
        self.init(frame:  frame)
        status = viewStatus
        text = viewText
        
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame:  frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        addConstraints()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.setupViews()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.bottomSafeAreaColour
        infoLabel.font = UIFont.boldRoboto18
        infoLabel.text = text
        
        if status == .selection1 {
            infoLabel.textColor = UIColor.red
            infoLabel.textAlignment = .left
        }
        else if status == .selection3 {
            infoLabel.textColor = UIColor.yellow
            infoLabel.textAlignment = .center
        }
        else if status == .selection5 {
            infoLabel.textColor = UIColor.white
            infoLabel.textAlignment = .right
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}
