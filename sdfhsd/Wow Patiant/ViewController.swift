//  ViewController.swift
//  Wow Patiant
//  Created by Amir on 30/04/2018.
//  Copyright © 2018 Amir. All rights reserved.

import UIKit
//import GoogleMaps
//import GooglePlaces

class ViewController: UIViewController {
    /*
    @IBOutlet weak var mapView: GMSMapView!
    var centerMapCoordinate:CLLocationCoordinate2D!
    var marker = GMSMarker()
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var placesClient : GMSPlacesClient!
    var zoomLevel : Float = 15.0
    
   
    
    // @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    // @IBOutlet weak var mapView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.isMyLocationEnabled = true
        //self.mapView.loca//
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
//        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
//        mapView.camera = camera
//    mapView.delegate = self
//        showMarker(position: camera.target)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
//        let marker = GMSMarker(position: coordinate)
//        marker.title = "Hello Amir"
//        marker.map = mapView
//        print("sdsdsdsds")
//    }
    
    
    
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
//showMarker(position: centerMapCoordinate)
        
        print("sdsdsdsds")
        self.placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mapView.isMyLocationEnabled = true
        //self.mapView.loca//
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D)
    {
        // let marker = GMSMarker()
        marker.position = centerMapCoordinate
        marker.map = self.mapView
        marker.title = "hello "
        marker.icon = UIImage(named: "checkBOxImg")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
}

/*extension ViewController: GMSMapViewDelegate{
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
    
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        marker.position = coordinate
    }
    
    // extension ViewController: GMSMapViewDelegate{
    //        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
    //            marker.position = coordinate
    //        }
    //}
}
*/
