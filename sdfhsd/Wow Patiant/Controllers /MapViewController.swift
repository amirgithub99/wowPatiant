//
//  MapViewController.swift
//  Wow Patient
//
//  Created by Amir on 27/04/2018.
//  Copyright © 2018 Amir. All rights reserved.

import UIKit
import GoogleMaps
import GooglePlaces

protocol MapViewLongLatDelegate : class {
    func getMapViewLongtitudeLatitude(longitude : Double, latitude : Double)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var centerMapCoordinate:CLLocationCoordinate2D!
    var marker = GMSMarker()
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var placesClient : GMSPlacesClient!
    var zoomLevel : Float = 15.0
    weak var mapViewDelegate : MapViewLongLatDelegate?
    
    var selectedLatitude = Double()
    var selectedLongitude =  Double()
    
     // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.mapView.isMyLocationEnabled = true
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()        
    }
    @IBAction func saveLongitutdeLatitude(_ sender: Any)
    {
        if (self.mapViewDelegate != nil)
        {
        self.mapViewDelegate?.getMapViewLongtitudeLatitude(longitude: self.selectedLongitude, latitude: self.selectedLatitude)
            self.navigationController?.popViewController(animated: true)
        }
    }
     // MARK:- Back To AppointmentFilterController
    @IBAction func goBackToAppointmentFilterController(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
   func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
   {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
       self.selectedLatitude = latitude
      self.selectedLongitude = longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //showMarker(position: centerMapCoordinate)
        self.placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)
    }
    
   // Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        self.selectedLatitude = (location?.coordinate.latitude)!
        self.selectedLongitude = (location?.coordinate.longitude)!
        //print("LLLLLL", location?.coordinate.latitude, location?.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
         self.mapView?.animate(to: camera)
         mapView.camera = camera
          mapView.delegate = self
         showMarker(position: camera.target)
        self.locationManager.stopUpdatingLocation()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.mapView.isMyLocationEnabled = true
    }
    
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D)
    {
        // let marker = GMSMarker()
        marker.position = centerMapCoordinate
        marker.map = self.mapView
        //marker.title = "hello "
       // marker.icon = UIImage(named: "checkBOxImg")
    }
    func showMarker(position: CLLocationCoordinate2D){
        // let marker = GMSMarker()
        marker.position = position
        marker.title = "Palo Alto"
        marker.snippet = "San Francisco"
        marker.map = mapView
        
        marker.icon = UIImage(named: "crossPurple")
        mapView.settings.myLocationButton = true
    }
}
extension MapViewController: GMSMapViewDelegate{
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
}
