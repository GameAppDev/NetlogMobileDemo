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
import PhotosUI
import MobileCoreServices

class AddImageViewController: UIViewController {

    @IBOutlet var navbarLabel: UILabel!
    @IBOutlet var backView: UIView!
    
    @IBOutlet var theImageView: UIImageView!
    
    @IBOutlet var deleteImgView: UIView!
    
    @IBOutlet var infoLabel: UILabel!
    
    @IBOutlet var retakeImgBGView: UIView!
    @IBOutlet var retakeImageLabel: UILabel!
    @IBOutlet var sendImgBGView: UIView!
    @IBOutlet var sendImageLabel: UILabel!
    @IBOutlet var addImgBGView: UIView!
    @IBOutlet var addImageLabel: UILabel!
    
    var image:Image? = Image()
    
    private lazy var imagePickerC: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.modalPresentationStyle = .fullScreen
        return imagePicker
    }()

    @available(iOS 14, *)
    private lazy var phPickerVC: PHPickerViewController = {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 1
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }()
    
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
        
        retakeImgBGView.backgroundColor = UIColor.white
        retakeImgBGView.layer.cornerRadius = retakeImgBGView.frame.height/2
        retakeImageLabel.font = UIFont.regularRoboto14
        retakeImageLabel.textColor = UIColor.white
        retakeImageLabel.text = "Fotoğraf çek"
        
        sendImgBGView.backgroundColor = UIColor.customBlueColour
        sendImgBGView.layer.cornerRadius = sendImgBGView.frame.height/2
        sendImageLabel.font = UIFont.regularRoboto14
        sendImageLabel.textColor = UIColor.white
        sendImageLabel.text = "Gönder"
        
        addImgBGView.backgroundColor = UIColor.white
        addImgBGView.layer.cornerRadius = addImgBGView.frame.height/2
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
                else {
                    self.showAlert(with: "No permission to open camera", title: "", yesButtonText: "Settings", noButtonText: "Cancel") {
                        Helper.openAppSettings()
                    }
                }
            }
        }
    }
    
    private func openGallery() {
        UINavigationBar.appearance().tintColor = UIColor.black
        if !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) { return }

        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            self.presentImagePicker()
        default:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.presentImagePicker()
                }
                else {
                    self.showAlert(with: "No permission to open Gallery", title: "", yesButtonText: "Settings", noButtonText: "Cancel") {
                        Helper.openAppSettings()
                    }
                }
            }
        }
    }
    
    private func presentImagePicker() {
        if #available(iOS 14, *) {
            getPhotosFromiOS14()
        }
        else {
            DispatchQueue.main.async {
                self.present(self.imagePickerC, animated: true)
            }
        }
    }
    
    @available(iOS 14, *)
    private func getPhotosFromiOS14() {
        //using PHPickerViewController
        DispatchQueue.main.async {
            self.present(self.phPickerVC, animated: true)
        }
    }
    
    private func openFiles() {
        UINavigationBar.appearance().tintColor = nil
        
        var documentPickerVC: UIDocumentPickerViewController
        documentPickerVC = UIDocumentPickerViewController(documentTypes: [String(kUTTypePNG), String(kUTTypeJPEG)], in: UIDocumentPickerMode.import)
        documentPickerVC.delegate = self
        documentPickerVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(documentPickerVC, animated: true, completion: nil)
    }
    
    
    private func setImageStatus(hasImage:Bool, selectedImage:UIImage?, imageType:String?) {
        if hasImage {
            if let imageData = selectedImage?.jpegData(compressionQuality: 0.4) {
                image?.data = imageData
                image?.type = imageType
                
                DispatchQueue.main.async { [self] in
                    deleteImgView.isHidden = false
                    theImageView.backgroundColor = UIColor.clear
                    theImageView.image = selectedImage
                    
                    retakeImageLabel.text = "Yeniden çek"
                }
            }
        }
        else {
            image = nil
            
            DispatchQueue.main.async { [self] in
                deleteImgView.isHidden = true
                theImageView.backgroundColor = UIColor.imageViewBGColour
                theImageView.image = UIImage(named: "")
                
                retakeImageLabel.text = "Fotoğraf çek"
            }
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
            debugPrint("Image Data: \(data) Image Type: \(type)")
            showAlert(with: "Are you sure to send \(type) image?", title: "", yesButtonText: "Yes", noButtonText: "No") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        showAlert(with: "Please take a photo to submit", title: "", yesButtonText: "OK", noButtonText: nil, yesTapped: nil)
    }
    
    @IBAction func addImageClicked(_ sender: UIButton) {
        showActionSheet(title: "Please add image from Device", message: nil, action1Title: "Open Gallery", action1Handler: { (_) in
            self.openGallery()
        }, action2Title: "Open Files", action2Handler: { (_) in
            self.openFiles()
        })
    }
}

extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        //get original image. Not live or edited images
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        var urlType:String = "jpeg"
        if picker.sourceType == .camera {
            urlType = "heic"
        }
        
        setImageStatus(hasImage: true, selectedImage: pickedImage, imageType: urlType)
    }
}

@available(iOS 14, *)
extension AddImageViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard let firstResult = results.first else { return }
        
        firstResult.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, _) in
            guard let image = object as? UIImage else { return }
            
            let urlType:String = "jpeg"
            
            self.setImageStatus(hasImage: true, selectedImage: image, imageType: urlType)
        })
    }
}

extension AddImageViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else { return }
        
        do {
            let urlData = try Data(contentsOf: myURL)
            debugPrint("\(urlData)")
            
            let urlImage = UIImage(contentsOfFile: myURL.path)
            
            let urlType:String = "jpeg"
            
            self.setImageStatus(hasImage: true, selectedImage: urlImage, imageType: urlType)
        }
        catch {
            debugPrint("No data")
        }
    }
}
