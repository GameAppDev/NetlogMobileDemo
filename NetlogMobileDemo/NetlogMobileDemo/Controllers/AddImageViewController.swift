//
// AddImageViewController.swift
// NetlogMobileDemo
//
// Created on 13.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit
import Photos

class AddImageViewController: UIViewController {

    @IBOutlet var navbarLabel: UILabel!
    @IBOutlet var backView: UIView!
    
    @IBOutlet var theImageView: UIImageView!
    
    @IBOutlet var deleteImgView: UIView!
    
    @IBOutlet var infoLabel: UILabel!
    
    @IBOutlet var retakeImageLabel: UILabel!
    @IBOutlet var sendImageLabel: UILabel!
    @IBOutlet var addImageLabel: UILabel!
    
    var image:Image? = Image()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.setupViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.rootVC.topSafeArea.backgroundColor = UIColor.black
        appDelegate.rootVC.bottomSafeArea.backgroundColor = UIColor.black
    }
    
    private func setupViews() {
        navbarLabel.font = UIFont.boldRoboto18
        navbarLabel.textColor = UIColor.white
        navbarLabel.text = "Yükleme Resmi"
        
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = backView.frame.height/2
        
        deleteImgView.isHidden = true
        deleteImgView.layer.cornerRadius = deleteImgView.frame.height/2
        
        theImageView.backgroundColor = UIColor.imageViewBGColour
        
        infoLabel.font = UIFont.regularRoboto14
        infoLabel.textColor = UIColor.white
        infoLabel.text = "Dorse kapak açık olmasına dikkat edin."
        
        retakeImageLabel.font = UIFont.regularRoboto14
        retakeImageLabel.textColor = UIColor.white
        retakeImageLabel.text = "Fotoğraf çek"
        sendImageLabel.font = UIFont.regularRoboto14
        sendImageLabel.textColor = UIColor.white
        sendImageLabel.text = "Gönder"
        addImageLabel.font = UIFont.regularRoboto14
        addImageLabel.textColor = UIColor.white
        addImageLabel.text = "Ekle"
    }
    
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.present(imagePicker, animated: true, completion: nil)
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func setImageStatus(hasImage:Bool, selectedImage:UIImage?, imageType:String?) {
        if hasImage {
            if let imageData = selectedImage?.jpegData(compressionQuality: 0.4) {
                image?.data = imageData
                image?.type = imageType
                
                deleteImgView.isHidden = false
                theImageView.backgroundColor = UIColor.clear
                theImageView.image = selectedImage
                
                retakeImageLabel.text = "Yeniden çek"
            }
        }
        else {
            image = nil
            
            deleteImgView.isHidden = true
            theImageView.backgroundColor = UIColor.imageViewBGColour
            theImageView.image = UIImage(named: "")
            
            retakeImageLabel.text = "Fotoğraf çek"
        }
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteImageClicked(_ sender: UIButton) {
        setImageStatus(hasImage: false, selectedImage: nil, imageType: nil)
    }
    
    @IBAction func retakeImageClicked(_ sender: UIButton) {
        showActionSheet(title: "Please take a photo", message: nil, action1Title: "Take a photo", action1Handler: { (_) in
            self.openCamera()
        }, action2Title: nil, action2Handler: { (_) in })
    }
    
    @IBAction func sendImageClicked(_ sender: UIButton) {
        if let data = image?.data, let type = image?.type {
            print("Image Data: \(data) Image Type: \(type)")
            showAlert(with: "Are you sure to send \(type) image?", title: "", yesButtonText: "Yes", noButtonText: "No") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        showAlert(with: "Please take a photo to submit", title: "", yesButtonText: "OK", noButtonText: nil, yesTapped: nil)
    }
    
    @IBAction func addImageClicked(_ sender: UIButton) {
        showAlert(with: "Image added successfully.", title: "", yesButtonText: "OK", noButtonText: nil, yesTapped: nil)
    }
}

extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        var urlType:String = "jpeg"
        if picker.sourceType == .camera {
            urlType = "heic"
        }
        
        setImageStatus(hasImage: true, selectedImage: pickedImage, imageType: urlType)
    }
}
