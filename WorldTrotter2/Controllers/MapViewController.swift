//
//  MapViewController.swift
//  WorldTrotter2
//
//  Created by Roderick Presswood on 10/9/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var pinIndex: Int = 0
    var annotationList: [MKPointAnnotation]!
    
    override func loadView() {
        super.loadView()
        
        //Creating pins in map
        let p1 = MKPointAnnotation()
        let p1String = NSLocalizedString("The hospital I was born in.", comment: "Pin shows where I was born")
        p1.title = p1String
        p1.coordinate = CLLocationCoordinate2D(latitude: 33.506325, longitude: -86.802122)
        let p2 = MKPointAnnotation()
        let p2String = NSLocalizedString("This is where I live now.", comment: "Pin shows where I live now")
        p2.title = p2String
        p2.coordinate = CLLocationCoordinate2D(latitude: 33.66217, longitude: -84.784012)
        let p3 = MKPointAnnotation()
        let p3String = NSLocalizedString("This cave is full of amazing gems.", comment: "First gemstone cave i've seen.")
        p3.title = p3String
        p3.coordinate = CLLocationCoordinate2D(latitude: 33.321882, longitude: -86.203513)
        annotationList = [p1,p2,p3]
        
        // Create a map view
        mapView = MKMapView()
        
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = false
        
        
        // Set it as *the* view of this view controller
        view = mapView
        
//        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        
        //Localizing strings
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString,satelliteString,hybridString])
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // Create button
        let showUserLocationButton = UIButton(type: .roundedRect)
        showUserLocationButton.backgroundColor = UIColor.purple.withAlphaComponent(0.8)
        let showUserLocationButtonString = NSLocalizedString("Show My Location", comment: "Shows My location")
        showUserLocationButton.setTitle(showUserLocationButtonString, for: .normal)
        showUserLocationButton.layer.cornerRadius = 5
        showUserLocationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showUserLocationButton)
        // setting up action for segmented control
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        // set up action for uibutton showuserlocationbutton
        
         showUserLocationButton.addTarget(self, action: #selector(MapViewController.showUserLocation(sender:)), for: .touchUpInside)
        
        //creating constraints to the segmented control
        
//        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
//        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        //using margins below instead of trailing anchors for the leading and trailing constraint of the segmented control
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        //Creating constraints for UIButton ShowMyLocation
        let upperConstraint = showUserLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        let leadConstraint = showUserLocationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailConstraint = showUserLocationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        //activating contraints to segmented control below
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        //activating constraints to showUserlocationButton control below
        upperConstraint.isActive = true
        leadConstraint.isActive = true
        trailConstraint.isActive = true
        
        //add pinLocationButton to app
        let pinLocationButton = UIButton()
        let pinLocationButtonString = NSLocalizedString("Pin Location", comment: "Shows Pin Location")
        pinLocationButton.setTitle(pinLocationButtonString, for: .normal)
        pinLocationButton.addTarget(self, action: #selector(getPinLocation(_:)), for: .touchUpInside)
        pinLocationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinLocationButton.setTitleColor(UIColor.black, for: .normal)
        pinLocationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinLocationButton)
        
        //Setting Constraints for pinLocationButton
        
        let topPinLocationButtonConstraint = pinLocationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55)
        let leadingPinLocationButtonConstraint = pinLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingPinLocationButtonConstraint = pinLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        //activating constraints to pinLocationButton control
        topPinLocationButtonConstraint.isActive = true
        leadingPinLocationButtonConstraint.isActive = true
        trailingPinLocationButtonConstraint.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    @objc func showUserLocation(sender: UIButton!){
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = !mapView.showsUserLocation
        
        if mapView.showsUserLocation == true {
            sender.setTitle("Hide Location", for: .normal)
        } else {
            sender.setTitle("Show Location", for: .normal)
        }
    }
    // function is used to show pinned locations
    @objc func getPinLocation(_ sender: UIButton){
        let region = MKCoordinateRegion(center: annotationList[pinIndex].coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotationList[pinIndex])
        pinIndex += 1
        pinIndex = pinIndex % 3
    }
    
    //Using MKMapViewDelegate functions
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.showsPointsOfInterest = true
        
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "")
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotationList[pinIndex], reuseIdentifier: "")
            pinView!.canShowCallout = true
            pinView!.tintColor = MKPinAnnotationView.greenPinColor()
        } else {
            pinView?.annotation = annotationList[pinIndex]
        }
        return pinView
    }
}
