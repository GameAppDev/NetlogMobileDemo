//
// HomeViewController.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var navbarView: UIView!
    @IBOutlet var navbarSTitleLabel: UILabel!
    @IBOutlet var navbarLTitleLabel: UILabel!
    
    @IBOutlet var notifCountBGView: UIView!
    @IBOutlet var notifCountLabel: UILabel!
    
    @IBOutlet var tabCollectionView: UICollectionView!
    let identifierTabItemCVC:String = "TabItemCollViewCell"
    var tabItemCell:TabItemCollectionViewCell?
    
    @IBOutlet var scrollableView: UIView!
    
    var tabImages:[TabImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        setTabImages()
        
        DispatchQueue.main.async {
            self.setupViews()
        }
        
        tabCollectionView.registerCell(nibName: "TabItemCollectionViewCell", identifier: identifierTabItemCVC)
        tabCollectionView.dataSource = self
        tabCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.rootVC.topSafeArea.backgroundColor = UIColor.topSafeAreaColour
        appDelegate.rootVC.bottomSafeArea.backgroundColor = UIColor.bottomSafeAreaColour
    }
    
    private func setupViews() {
        navbarView.backgroundColor = UIColor.navBarBGColour
        
        navbarSTitleLabel.font = UIFont.regularRoboto12
        navbarSTitleLabel.textColor = UIColor.textColour
        navbarSTitleLabel.text = "Berlin" //Should be dynamic
        navbarLTitleLabel.font = UIFont.boldRoboto18
        navbarLTitleLabel.textColor = UIColor.textColour
        navbarLTitleLabel.text = "Adlershof" //Should be dynamic
        
        notifCountBGView.backgroundColor = UIColor.red
        notifCountBGView.layer.cornerRadius = notifCountBGView.frame.height/2
        notifCountLabel.font = UIFont.boldRoboto10
        notifCountLabel.textColor = UIColor.white
        notifCountLabel.text = "2"
        
        tabCollectionView.backgroundColor = UIColor.selectionViewColour
        
        let mapView = MapView(frame: CGRect(x: 0, y: 0, width: scrollableView.frame.width, height: scrollableView.frame.height))
        mapView.documentButton.addTarget(self, action: #selector(documentClicked(sender:)), for: .touchUpInside)
        mapView.bottomBarConfirmButton.addTarget(self, action: #selector(confirmClicked(sender:)), for: .touchUpInside)
        scrollableView.addSubview(mapView)
    }
    
    private func setTabImages() {
        let images:[String] = ["Tab1Icon", "Tab2Icon", "Tab3Icon", "Tab4Icon", "Tab5Icon"]
        
        for (_, image) in images.enumerated() {
            let newTabImage = TabImage(imageKey: image, isSelected: false)
            tabImages.append(newTabImage)
        }
    }
    
    @objc func documentClicked(sender:UIButton) {
        if let imageVC = appDelegate.mainStoryboard.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController {
            imageVC.documentImage = UIImage(named: "DocumentImage")
            imageVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            present(imageVC, animated: true, completion: nil)
        }
    }
    
    @objc func confirmClicked(sender:UIButton) {
        if let addImageVC = appDelegate.mainStoryboard.instantiateViewController(withIdentifier: "AddImageVC") as? AddImageViewController {
            navigationController?.pushViewController(addImageVC, animated: true)
        }
    }
    
    @IBAction func showNotificationsClicked(_ sender: UIButton) {
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        tabItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierTabItemCVC, for: indexPath) as? TabItemCollectionViewCell
        
        tabItemCell?.tabImageView.image = UIImage(named: "")
        if let image = tabImages[indexPath.row].imageKey {
            tabItemCell?.tabImageView.image = UIImage(named: image)
        }
        
        (indexPath.row == tabImages.count-1) ? (tabItemCell?.seperatorView.isHidden = true) : (tabItemCell?.seperatorView.isHidden = false)
        
        return tabItemCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(64).ws, height: CGFloat(34).ws)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let oldIndex = tabImages.firstIndex(where: {$0.isSelected == true}) {
            tabImages[oldIndex].imageKey = "Tab\(oldIndex+1)Icon" //Tab1Icon
            tabImages[oldIndex].isSelected = false
        }
        tabImages[indexPath.row].isSelected = true
        tabImages[indexPath.row].imageKey = "SelectedTab\(indexPath.row+1)Icon" //SelectedTab1Icon
        
        DispatchQueue.main.async {
            self.tabCollectionView.reloadData()
        }
    }
}
