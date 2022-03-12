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
import GoogleMaps

class HomeViewController: UIViewController {

    @IBOutlet var navbarView: UIView!
    @IBOutlet var navbarSTitleLabel: UILabel!
    @IBOutlet var navbarLTitleLabel: UILabel!
    
    @IBOutlet var selectionView: UIView!
    
    @IBOutlet var mapView: UIView!
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longtitudeLabel: UILabel!
    
    @IBOutlet var infoView: UIView!
    
    @IBOutlet var bottomBarView: UIView!
    @IBOutlet var bottomBarInfoLabel: UILabel!
    @IBOutlet var bottomBarConfirmButton: UIButton!
    
    @IBOutlet var infoViewBottomC: NSLayoutConstraint! //-310 -20
    
    var googleMap:GMSMapView?
    let defaultMaxZoom:Float = 14
    let defaultMinZoom:Float = 1
    
    let locationManager = CLLocationManager()
    
    var user:User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.setupViews()
            self.drawMap(defaultLatitude: -33.86, defaultLongitude: 151.20)
        }
        
        setUpLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLocationTimerStatus(isOn: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setLocationTimerStatus(isOn: false)
    }
    
    private func setupViews() {
        navbarView.backgroundColor = UIColor.navBarBGColour
        
        navbarSTitleLabel.font = UIFont.regularRoboto12
        navbarSTitleLabel.textColor = UIColor.textColour
        navbarSTitleLabel.text = "Berlin" //Should be dynamic
        navbarLTitleLabel.font = UIFont.boldRoboto18
        navbarLTitleLabel.textColor = UIColor.textColour
        navbarLTitleLabel.text = "Adlershof" //Should be dynamic
        
        selectionView.backgroundColor = UIColor.selectionViewColour
        
        latitudeLabel.font = UIFont.mediumRoboto16
        latitudeLabel.textColor = UIColor.textColour
        longtitudeLabel.font = UIFont.mediumRoboto16
        longtitudeLabel.textColor = UIColor.textColour
        
        infoView.backgroundColor = UIColor.white
        
        bottomBarView.roundCorners([.topLeft, .topRight], radius: CGFloat(20).ws)
        bottomBarView.backgroundColor = UIColor.bottomSafeAreaColour
        
        bottomBarInfoLabel.font = UIFont.regularRoboto14
        bottomBarInfoLabel.textColor = UIColor.white
        bottomBarInfoLabel.text = "YÜKLEME AKIŞI - 1/4" //Should be dynamic
        
        bottomBarConfirmButton.titleLabel?.font = UIFont.mediumRoboto16
        bottomBarConfirmButton.setTitleColor(UIColor.bottomSafeAreaColour, for: .normal)
        bottomBarConfirmButton.setTitle("YÜKLEME NOKTASINA GELDİM", for: .normal)
        bottomBarConfirmButton.backgroundColor = UIColor.white
        bottomBarConfirmButton.layer.cornerRadius = CGFloat(10).ws
        
        infoViewBottomC.constant = CGFloat(-310).ws
    }
    
    private func setUpLocationServices() {
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func setLocationTimerStatus(isOn:Bool) {
        TimerManager.locationTimer?.invalidate()
        TimerManager.locationTimer = nil
        if isOn {
            TimerManager.locationTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(6), repeats: true, block: { (timer) in
                self.locationManager.startUpdatingLocation()
            })
            TimerManager.locationTimer?.fire()
        }
    }
    
    private func drawMap(defaultLatitude:CGFloat, defaultLongitude:CGFloat) {
        let cameraPosition = GMSCameraPosition.camera(withLatitude: defaultLatitude, longitude: defaultLongitude, zoom: defaultMaxZoom)
        googleMap = GMSMapView.map(withFrame: CGRect.zero, camera: cameraPosition)
        googleMap?.setMinZoom(defaultMinZoom, maxZoom: defaultMaxZoom)
        googleMap?.delegate = self
        mapView.addSubview(googleMap!)
        
        googleMap?.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            googleMap!.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 0),
            googleMap!.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: 0),
            googleMap!.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 0),
            googleMap!.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func placeUserLocation(userLocation: CLLocationCoordinate2D) {
        //googleMap!.clear()
        
        let userLatitude:CLLocationDegrees = userLocation.latitude
        let userLongitude:CLLocationDegrees = userLocation.longitude

        let userMarker:GMSMarker = GMSMarker()
        userMarker.position = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        userMarker.tracksViewChanges = false

        userMarker.map = self.googleMap!
        
        DispatchQueue.main.async {
            self.showCamera()
        }
    }
    
    private func showCamera() {
        var cameraPosition:GMSCameraPosition?
        
        if let location = user.location2D {
            cameraPosition = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: defaultMaxZoom)
        }
        if let position = cameraPosition {
            googleMap?.animate(to: position)
        }
    }
    
    @IBAction func showMoreInfoClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.infoViewBottomC.constant = CGFloat(-20).ws
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func showLessInfoClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.infoViewBottomC.constant = CGFloat(-310).ws
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
    }
}

extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMap?.center = self.mapView.center
        latitudeLabel.text = "Latitude: \(String(format: "%.3f",  position.target.latitude))"
        longtitudeLabel.text = "Longtitude: \(String(format: "%.3f",  position.target.longitude))"
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("User marker clicked")
        return true
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        locationManager.stopUpdatingLocation()
        
        let coordinate = location.coordinate
        user.location2D = coordinate
        print("Location Updated - \(coordinate)")
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.placeUserLocation(userLocation: coordinate)
        })
            
        //convertToAddresUsing(location: coordinate)
    }
    
    //Can not use the Geocoding API because it is not free
    private func convertToAddresUsing(location: CLLocationCoordinate2D) {
        ServiceManager.shared.getAddressDetail(coordinate: location) { (response, errorCode, isOK) in
            if isOK {
                if let geoAddress = response {
                    self.user.geoLocatedAddress = geoAddress
                }
            }
            else {
                self.showAlert(with: "\(errorCode): \(response ?? "No Response")")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed - \(error.localizedDescription)")
    }
}
