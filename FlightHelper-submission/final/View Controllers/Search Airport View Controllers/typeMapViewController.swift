//
//  typeMapViewController.swift
//  1
//
//  Created by yzn123 on 12/2/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit
import MapKit

class typeMapViewController: UIViewController {

    //initial map type
    var t = "Hybrid"
    
    // The amount of north-to-south distance (measured in meters) to use for the span.
    let latitudinalSpanInMeters: Double = 8040.672    // = 0.5 mile
    
    // The amount of east-to-west distance (measured in meters) to use for the span.
    let longitudinalSpanInMeters: Double = 8040.672   // = 0.5 mile
    var lat = ""
    var long = ""
    var radius = ""
    var type = ""
    //passed from previous view controller
    var geo = [CLLocationCoordinate2D]()
  
    //hold the array of dictionary of "results"
    var resultArray: [Dictionary<String, AnyObject>] = []
    @IBOutlet var mapp: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //doing json query and process it
        
        let nameQuery = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + lat + "," + long + "&radius=" + radius + "&type=" + type + "&key=AIzaSyABbWSh5r0q_qb2pbU5WpLuIB0AY5Mxo3g"
        let encoded = nameQuery.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url: URL? = URL(string: encoded!)
        
        let jsonData: NSData?
        do {
            jsonData = try NSData(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
        }
        catch {
            showAlertMessage(messageHeader: "Failed to read from API", messageBody: "No api data found!")
            return
        }
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            do {
                /*
                 JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
                 JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                resultArray = dictionaryOfJsonData["results"] as! [Dictionary<String, AnyObject>]
                if (resultArray.count == 0) {
                    showAlertMessage(messageHeader: "No result found", messageBody: "0 result founded!")
                }
                else {
                    // Do any additional setup after loading the view.
                    //-----------------------------
                    // Dress up the map view object
                    //-----------------------------
                    
                    if (t == "Hybrid") {
                        self.mapp.mapType = MKMapType.standard
                    }
                    else {
                        self.mapp.mapType = MKMapType.hybrid
                    }
                    
                    
                    
                    self.mapp.isZoomEnabled = true
                    self.mapp.isScrollEnabled = true
                    self.mapp.isRotateEnabled = false
                    for i in 0...(resultArray.count - 1) {
                        let tem = resultArray[i]
                        let geometry = tem["geometry"] as! Dictionary<String, AnyObject>
                        let location = geometry["location"] as! Dictionary<String, AnyObject>
                        let latt = location["lat"] as! Double
                        let long = location["lng"] as! Double
                        let name = tem["name"] as! String
                        let address = tem["vicinity"] as! String
                        let latfinal = Double(latt)
                        let longfinal = Double(long)
                        let g2d  = CLLocationCoordinate2D(latitude: latfinal, longitude: longfinal)
                        
                        //
                        // Address Center Geolocation
                        let addressCenterLocation = g2d
                        // Define map's visible region
                        let addressMapRegion: MKCoordinateRegion? = MKCoordinateRegion(center: addressCenterLocation, latitudinalMeters: self.latitudinalSpanInMeters, longitudinalMeters: self.longitudinalSpanInMeters)
                        
                        // Set the mapView to show the defined visible region
                        self.mapp.setRegion(addressMapRegion!, animated: true)
                        
                        //*************************************
                        // Prepare and Set Address Annotation
                        //*************************************
                        
                        // Instantiate an object from the MKPointAnnotation() class and place its obj ref into local variable annotation
                        let annotation = MKPointAnnotation()
                        
                        // Dress up the newly created MKPointAnnotation() object
                        annotation.coordinate = addressCenterLocation
                        
                        
                        annotation.title = name
                        annotation.subtitle = address
                        
                        
                        // Add the created and dressed up MKPointAnnotation() object to the map view
                        self.mapp.addAnnotation(annotation)
                        
                    }
                    }
                    
                    
                    
                    
                
                
            }
            catch{
                showAlertMessage(messageHeader: "Failed to read from API", messageBody: "No api data found!")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
     -----------------------------------
     MARK: - swap two map mode on Shake Gesture
     -----------------------------------
     */
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // If the detected motion is a Shake Gesture
        
        if event!.subtype == UIEvent.EventSubtype.motionShake {
            //swaps two countries, from -> to, to -> from
            if (t == "Hybrid") {
                t = "Standard"
            
            }
            else if (t == "Standard") {
                t = "Hybrid"
            }
            self.viewWillAppear(true)
            
        }
        
    }
    //called when shake gesture happened
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        //doing json query and process it
        let nameQuery = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + lat + "," + long + "&radius=" + radius + "&type=" + type + "&key=AIzaSyABbWSh5r0q_qb2pbU5WpLuIB0AY5Mxo3g"
        let encoded = nameQuery.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url: URL? = URL(string: encoded!)
        
        let jsonData: NSData?
        do {
            jsonData = try NSData(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
        }
        catch {
            showAlertMessage(messageHeader: "Failed to read from API", messageBody: "No api data found!")
            return
        }
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            do {
                /*
                 JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
                 JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                resultArray = dictionaryOfJsonData["results"] as! [Dictionary<String, AnyObject>]
                if (resultArray.count == 0) {
                    showAlertMessage(messageHeader: "No result found", messageBody: "0 result founded!")
                }
                else {
                    // Do any additional setup after loading the view.
                    //-----------------------------
                    // Dress up the map view object
                    //-----------------------------
                    if (t == "Hybrid") {
                        self.mapp.mapType = MKMapType.standard
                    }
                    else {
                        self.mapp.mapType = MKMapType.hybrid
                    }
                    
                    self.mapp.isZoomEnabled = true
                    self.mapp.isScrollEnabled = true
                    self.mapp.isRotateEnabled = false
                    for i in 0...(resultArray.count - 1) {
                        let tem = resultArray[i]
                        let geometry = tem["geometry"] as! Dictionary<String, AnyObject>
                        let location = geometry["location"] as! Dictionary<String, AnyObject>
                        let latt = location["lat"] as! Double
                        let long = location["lng"] as! Double
                        let name = tem["name"] as! String
                        let address = tem["vicinity"] as! String
                        let latfinal = Double(latt)
                        let longfinal = Double(long)
                        let g2d  = CLLocationCoordinate2D(latitude: latfinal, longitude: longfinal)
                        
                        //
                        // Address Center Geolocation
                        let addressCenterLocation = g2d
                        // Define map's visible region
                        let addressMapRegion: MKCoordinateRegion? = MKCoordinateRegion(center: addressCenterLocation, latitudinalMeters: self.latitudinalSpanInMeters, longitudinalMeters: self.longitudinalSpanInMeters)
                        
                        // Set the mapView to show the defined visible region
                        self.mapp.setRegion(addressMapRegion!, animated: true)
                        
                        //*************************************
                        // Prepare and Set Address Annotation
                        //*************************************
                        
                        // Instantiate an object from the MKPointAnnotation() class and place its obj ref into local variable annotation
                        let annotation = MKPointAnnotation()
                        
                        // Dress up the newly created MKPointAnnotation() object
                        annotation.coordinate = addressCenterLocation
                        
                        
                        annotation.title = name
                        annotation.subtitle = address
                        
                        
                        // Add the created and dressed up MKPointAnnotation() object to the map view
                        self.mapp.addAnnotation(annotation)
                        
                    }
                }
                
                
                
                
                
                
            }
            catch{
                showAlertMessage(messageHeader: "Failed to read from API", messageBody: "No api data found!")
            }
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
