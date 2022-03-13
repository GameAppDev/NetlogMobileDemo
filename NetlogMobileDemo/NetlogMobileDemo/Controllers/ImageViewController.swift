//
// ImageViewController.swift
// NetlogMobileDemo
//
// Created on 12.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var cancelView: UIView!
    
    @IBOutlet var documentScrollView: UIScrollView!
    @IBOutlet var documentImageView: UIImageView!
    
    var documentImage:UIImage?
    
    let minZoomScale:CGFloat = 1.0
    let maxZoomScale:CGFloat = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.setupViews()
        }
        
        documentImageView.image = documentImage
        
        documentScrollView.delegate = self
        documentScrollView.minimumZoomScale = minZoomScale
        documentScrollView.maximumZoomScale = maxZoomScale
        
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(zoomInOutRecognized(_:)))
        doubleTapGR.delegate = self
        doubleTapGR.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.rootVC.topSafeArea.backgroundColor = UIColor.black
        appDelegate.rootVC.bottomSafeArea.backgroundColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate.rootVC.topSafeArea.backgroundColor = UIColor.topSafeAreaColour
        appDelegate.rootVC.bottomSafeArea.backgroundColor = UIColor.bottomSafeAreaColour
    }
    
    private func setupViews() {
        cancelView.backgroundColor = UIColor.white
        cancelView.layer.cornerRadius = cancelView.frame.height/2
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return documentImageView
    }
}

extension ImageViewController: UIGestureRecognizerDelegate {
    
    @objc func zoomInOutRecognized(_ gesture: UITapGestureRecognizer) {
        if documentScrollView.zoomScale == minZoomScale {
            documentScrollView.setZoomScale(maxZoomScale, animated: true)
        }
        else {
            documentScrollView.setZoomScale(minZoomScale, animated: true)
        }
    }
}
