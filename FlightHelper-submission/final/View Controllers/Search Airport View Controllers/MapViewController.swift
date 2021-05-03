//
//  MapViewController.swift
//  1
//
//  Created by yzn123 on 12/1/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    //map title
    var titleD = ""
    //map type
    var mapType = ""
    
    @IBOutlet var mapView: MKMapView!
    
    // The amount of north-to-south distance (measured in meters) to use for the span.
    let latitudinalSpanInMeters: Double = 804.672    // = 0.5 mile
    
    // The amount of east-to-west distance (measured in meters) to use for the span.
    let longitudinalSpanInMeters: Double = 804.672   // = 0.5 mile
    
    var geo = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--------------------------------------------------
        // Adjust the title to fit within the navigation bar
        //--------------------------------------------------
        
        let navigationBarWidth = self.navigationController?.navigationBar.frame.width
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let labelRect = CGRect(x: 0, y: 0, width: navigationBarWidth!, height: navigationBarHeight!)
        let titleLabel = UILabel(frame: labelRect)
        titleLabel.text = titleD
        titleLabel.font = titleLabel.font.withSize(12)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel

        // Do any additional setup after loading the view.
        //-----------------------------
        // Dress up the map view object
        //-----------------------------
        if (self.mapType == "Standard") {
            self.mapView.mapType = MKMapType.standard
        }
        else if (self.mapType == "Satellite") {
            self.mapView.mapType = MKMapType.satellite
        }
        else if (self.mapType == "Hybrid") {
            self.mapView.mapType = MKMapType.hybrid
        }
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        self.mapView.isRotateEnabled = false
        // Address Center Geolocation
        let addressCenterLocation = geo
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
        
        annotation.subtitle = ""
        
        // Add the created and dressed up MKPointAnnotation() object to the map view
        self.mapView.addAnnotation(annotation)
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
