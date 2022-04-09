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
    private var tabItemCell:TabItemCollectionViewCell?
    
    @IBOutlet var scrollableView: UIView!
    
    private var tabImages:[TabImage] = []
    
    private let selectionScrollView:UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        getTabItems()
        
        DispatchQueue.main.async {
            self.setupViews()
            self.getScrollViewItems()
        }
        
        tabCollectionView.registerCell(nibName: "TabItemCollectionViewCell", identifier: TabItemCollectionViewCell().identifier)
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
        notifCountLabel.text = "2" //Should be dynamic
        
        tabCollectionView.backgroundColor = UIColor.selectionViewColour
    }
    
    private func getTabItems() {
        let images:[String] = ["Tab1Icon", "Tab2Icon", "Tab3Icon", "Tab4Icon", "Tab5Icon"]
        
        for (_, image) in images.enumerated() {
            let newTabImage = TabImage(imageKey: image, isSelected: false)
            tabImages.append(newTabImage)
        }
    }
    
    private func setTabItems(selectedIndex:Int) {
        if let oldIndex = tabImages.firstIndex(where: {$0.isSelected == true}) {
            tabImages[oldIndex].imageKey = "Tab\(oldIndex+1)Icon" //Tab1Icon
            tabImages[oldIndex].isSelected = false
        }
        tabImages[selectedIndex].isSelected = true
        tabImages[selectedIndex].imageKey = "SelectedTab\(selectedIndex+1)Icon" //SelectedTab1Icon
        
        DispatchQueue.main.async {
            self.tabCollectionView.reloadData()
            self.setScrollViewItems(index: selectedIndex)
        }
    }
    
    private func getScrollViewItems() {
        let defaultGCRect:CGRect = CGRect(x: 0, y: 0, width: scrollableView.frame.width, height: scrollableView.frame.height)
        
        let selection1View = DefaultView(frame: defaultGCRect, viewStatus: .selection1, viewText: "First View")
        
        let selection2View = MapView(frame: defaultGCRect, isOpen: true)
        selection2View.documentButton.addTarget(self, action: #selector(documentClicked(sender:)), for: .touchUpInside)
        selection2View.bottomBarConfirmButton.addTarget(self, action: #selector(confirmClicked(sender:)), for: .touchUpInside)
        
        let selection3View = DefaultView(frame: defaultGCRect, viewStatus: .selection3, viewText: "Third View")
        
        let selection4View = MapView(frame: defaultGCRect, isOpen: false)
        selection4View.documentButton.addTarget(self, action: #selector(documentClicked(sender:)), for: .touchUpInside)
        selection4View.bottomBarConfirmButton.addTarget(self, action: #selector(confirmClicked(sender:)), for: .touchUpInside)
        
        let selection5View = DefaultView(frame: defaultGCRect, viewStatus: .selection5, viewText: "Fifth View")
        
        let selectionViews:[UIView] = [selection1View, selection2View, selection3View, selection4View, selection5View]
        
        selectionScrollView.showsHorizontalScrollIndicator = false
        selectionScrollView.isScrollEnabled = false //prevent to scroll
        selectionScrollView.isPagingEnabled = true
        selectionScrollView.contentSize = CGSize(width: (scrollableView.frame.width * CGFloat(selectionViews.count)), height: scrollableView.frame.height)
        selectionScrollView.frame = defaultGCRect
        
        for (index, _) in selectionViews.enumerated() {
            selectionScrollView.addSubview(selectionViews[index])
            selectionViews[index].frame = CGRect(x: (scrollableView.frame.width * CGFloat(index)), y: 0, width: scrollableView.frame.width, height: scrollableView.frame.height)
        }
        
        scrollableView.addSubview(selectionScrollView)
        
        scrollableView.setNeedsLayout()
        scrollableView.layoutIfNeeded()
        
        setTabItems(selectedIndex: 0) //default value when screen come up
    }
    
    private func setScrollViewItems(index:Int) {
        selectionScrollView.setContentOffset(CGPoint(x: (scrollableView.frame.width * CGFloat(index)), y: 0), animated: true)
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
        showAlert(with: "Notifications was read", title: "", yesButtonText: "Ok", noButtonText: nil) {
            self.notifCountBGView.isHidden = true
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        tabItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabItemCollectionViewCell().identifier, for: indexPath) as? TabItemCollectionViewCell
        
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
        setTabItems(selectedIndex: indexPath.row)
    }
}
