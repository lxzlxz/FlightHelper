//
//  RouteMapViewController.swift
//  final
//
//  Created by Yifan Zhou on 2018/12/2.
//  Copyright © 2018年 Yifan Zhou. All rights reserved.
//

import UIKit
import MapKit

class RouteMapViewController: UIViewController {

    var titleD = ""
    var mapType = "Standard"
    
    @IBOutlet var mapView: MKMapView!
    
    // The amount of north-to-south distance (measured in meters) to use for the span.
    let latitudinalSpanInMeters: Double = 804000.672    // = 0.5 * 1000 mile
    
    // The amount of east-to-west distance (measured in meters) to use for the span.
    let longitudinalSpanInMeters: Double = 804000.672   // = 0.5 * 1000 mile
    
    var airplaneGeoArray = [Double]()
    var arrivalAirportGeoArray = [Double]()
    var depatureAirportGeoArray = [Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //-----------------------------
        // Dress up the map view object
        //-----------------------------
        self.mapView.mapType = MKMapType.standard
        
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        self.mapView.isRotateEnabled = false
        if !airplaneGeoArray.isEmpty{
            let airplaneGeo = CLLocationCoordinate2DMake(airplaneGeoArray[0], airplaneGeoArray[1])
            // Address Center Geolocation
            let addressCenterLocation = airplaneGeo
            // Define map's visible region
            let addressMapRegion: MKCoordinateRegion? = MKCoordinateRegion(center: addressCenterLocation, latitudinalMeters: self.latitudinalSpanInMeters, longitudinalMeters: self.longitudinalSpanInMeters)
            
            // Set the mapView to show the defined visible region
            self.mapView.setRegion(addressMapRegion!, animated: true)
            
            //*************************************
            // Prepare and Set Address Annotation
            //*************************************
            
            // Instantiate an object from the MKPointAnnotation() class and place its obj ref into local variable annotation
            let annotation = MKPointAnnotation()
            
            // Dress up the newly created MKPointAnnotation() object
            annotation.coordinate = addressCenterLocation
            
            annotation.subtitle = "Airplane"
            
            // Add the created and dressed up MKPointAnnotation() object to the map view
            self.mapView.addAnnotation(annotation)
        }
        
        
        
        
        /*
         add depature airport geo
         */
        
        
        if !depatureAirportGeoArray.isEmpty{
            let depatureAirportGeo = CLLocationCoordinate2DMake(depatureAirportGeoArray[0], depatureAirportGeoArray[1])
            // Address Center Geolocation
            let addressCenterLocation2 = depatureAirportGeo
            // Define map's visible region
            let addressMapRegion2: MKCoordinateRegion? = MKCoordinateRegion(center: addressCenterLocation2, latitudinalMeters: self.latitudinalSpanInMeters, longitudinalMeters: self.longitudinalSpanInMeters)
            
            // Set the mapView to show the defined visible region
            self.mapView.setRegion(addressMapRegion2!, animated: true)
            
            
            // Instantiate an object from the MKPointAnnotation() class and place its obj ref into local variable annotation
            let annotation2 = MKPointAnnotation()
            
            // Dress up the newly created MKPointAnnotation() object
            annotation2.coordinate = addressCenterLocation2
            
            annotation2.subtitle = "Depature Airport"
            
            // Add the created and dressed up MKPointAnnotation() object to the map view
            self.mapView.addAnnotation(annotation2)
        }
        
        
        
        /*
         add arrival airport geo
         */
        if !arrivalAirportGeoArray.isEmpty{
            let arrivalAirportGeo = CLLocationCoordinate2DMake(arrivalAirportGeoArray[0], arrivalAirportGeoArray[1])
            // Address Center Geolocation
            let addressCenterLocation3 = arrivalAirportGeo
            // Define map's visible region
            let addressMapRegion3: MKCoordinateRegion? = MKCoordinateRegion(center: addressCenterLocation3, latitudinalMeters: self.latitudinalSpanInMeters, longitudinalMeters: self.longitudinalSpanInMeters)
            
            // Set the mapView to show the defined visible region
            self.mapView.setRegion(addressMapRegion3!, animated: true)
            
            // Instantiate an object from the MKPointAnnotation() class and place its obj ref into local variable annotation
            let annotation3 = MKPointAnnotation()
            
            // Dress up the newly created MKPointAnnotation() object
            annotation3.coordinate = addressCenterLocation3
            
            annotation3.subtitle = "Arrival Airport"
            
            // Add the created and dressed up MKPointAnnotation() object to the map view
            self.mapView.addAnnotation(annotation3)
        }
    }
    
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    /*
     ------------------------------------------
     MARK: - MKMapViewDelegate Protocol Methods
     ------------------------------------------
     */
    
    /*
     Asks the delegate for a renderer object to use when drawing the specified overlay. [Apple]
     mapView    --> The map view that requested the renderer object.
     overlay    --> The overlay object that is about to be displayed.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        /*
         Instantiate a MKPolylineRenderer object for visual polyline representation
         of the directions to be displayed as an overlay on top of the map.
         */
        let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        // Dress up the polyline for visual representation of directions
        polylineRenderer.strokeColor = UIColor.red
        polylineRenderer.lineWidth = 1.0
        
        return polylineRenderer
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        // Starting to load the map. Show the animated activity indicator in the status bar
        // to indicate to the user that the map view object is busy loading the map.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // Finished loading the map. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        
        // An error occurred during the map load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: "Unable to Load the Map!",
                                                message: "Error description: \(error.localizedDescription)",
            preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    

}
