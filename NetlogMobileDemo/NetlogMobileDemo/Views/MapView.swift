//
// MapView.swift
// NetlogMobileDemo
//
// Created on 15.03.2022.
// Oguzhan Yalcin
//
//
//


import UIKit
import GoogleMaps

class MapView: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet var mapView: UIView!
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longtitudeLabel: UILabel!
    
    @IBOutlet var infoCollectionView: UICollectionView!
    let identifierTransportationInfoCVC:String = "TransportationInfoCollViewCell"
    var transInfoCell:TransportationInfoCollectionViewCell?
    
    @IBOutlet var documentButton: UIButton!
    
    @IBOutlet var bottomBarView: UIView!
    @IBOutlet var bottomBarInfoLabel: UILabel!
    @IBOutlet var bottomBarConfirmButton: UIButton!
    
    @IBOutlet var infoViewBottomC: NSLayoutConstraint!
    
    var googleMap:GMSMapView?
    let defaultMaxZoom:Float = 14
    let defaultMinZoom:Float = 1
    
    let locationManager = CLLocationManager()
    
    var user:User = User()
    
    var infos:[TransportationInfoResponse] = []
    
    override init(frame: CGRect) {
        super.init(frame:  frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        DispatchQueue.main.async {
            self.setupViews()
            self.drawMap(defaultLatitude: -33.86, defaultLongitude: 151.20)
        }
        
        setTransportationInfos()
        
        addSubview(view)
        
        addConstraints()
        
        setUpLocationServices()
        
        setLocationTimerStatus(isOn: true)
        
        infoCollectionView.registerCell(nibName: "TransportationInfoCollectionViewCell", identifier: identifierTransportationInfoCVC)
        infoCollectionView.dataSource = self
        infoCollectionView.delegate = self
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func setupViews() {
        
        latitudeLabel.font = UIFont.mediumRoboto16
        latitudeLabel.textColor = UIColor.textColour
        longtitudeLabel.font = UIFont.mediumRoboto16
        longtitudeLabel.textColor = UIColor.textColour
        
        infoCollectionView.contentInset = UIEdgeInsets(top: CGFloat(20).ws, left: 0, bottom: CGFloat(10).ws, right: 0)
        
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
        
        infoViewBottomC.constant = CGFloat(-20).ws
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setTransportationInfos() {
        let titles:[String] = ["Yük Tipi", "Yükleme Tipi", "Yükleme Adedi", "Yüklerin Kilosu", "Yükleme Saati", "Hacim", "Çıkış Gümrük"]
        let answers:[String] = ["Genel Kargo", "Paletli", "243", "24 Ton", "14:30", "67 m3", "Kapıkule"]
        
        for (index, title) in titles.enumerated() {
            let newInfo = TransportationInfoResponse(title: title, info: answers[index])
            infos.append(newInfo)
        }
    }
    
    private func setUpLocationServices() {
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setLocationTimerStatus(isOn:Bool) {
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
}

extension MapView: GMSMapViewDelegate {
    
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
        debugPrint("User marker clicked")
        return true
    }
}

extension MapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        locationManager.stopUpdatingLocation()
        
        let coordinate = location.coordinate
        user.location2D = coordinate
        debugPrint("Location Updated - \(coordinate)")
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.placeUserLocation(userLocation: coordinate)
        })
            
        //convertToAddresUsing(location: coordinate) //Cannot use
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Location failed - \(error.localizedDescription)")
    }
}

extension MapView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        infos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(12).ws
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        transInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierTransportationInfoCVC, for: indexPath) as? TransportationInfoCollectionViewCell
        
        transInfoCell?.titleLabel.text = infos[indexPath.row].title
        transInfoCell?.infoLabel.text = infos[indexPath.row].info
        
        return transInfoCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(122).ws, height: CGFloat(33).ws)
    }
}

extension MapView {
    
    //Cannot use the Geocoding API because it is not free
    private func convertToAddresUsing(location: CLLocationCoordinate2D) {
        ServiceManager.shared.getAddressDetail(coordinate: location) { (response, errorCode, isOK) in
            if isOK {
                if let geoAddress = response {
                    self.user.geoLocatedAddress = geoAddress
                }
            }
        }
    }
}

