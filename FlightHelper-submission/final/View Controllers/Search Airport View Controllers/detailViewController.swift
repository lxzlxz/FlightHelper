//
//  detailViewController.swift
//  1
//
//  Created by yzn123 on 12/1/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit
import MapKit
class detailViewController: UIViewController {
    
    //hold the array of dictionary of "results"
    var dataPassed = Dictionary<String, AnyObject>()
    //airport name
    @IBOutlet var name: UILabel!
    //airport code
    @IBOutlet var code: UILabel!
    //airport lat
    @IBOutlet var lat: UILabel!
    //airport long
    @IBOutlet var long: UILabel!
    
    //airport timezone
    @IBOutlet var timezone: UILabel!
    //airport gmt
    @IBOutlet var gmt: UILabel!
    //airport country
    @IBOutlet var country: UILabel!
    //airport map type
    @IBOutlet var map: UISegmentedControl!
    
    //chosen type
    var type = ""
    
    //go to nearby functionality when clicked the button
    @IBAction func Go(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Nearby", sender: self)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = dataPassed["nameAirport"] as? String
        code.text = dataPassed["codeIataAirport"] as? String
        lat.text = dataPassed["latitudeAirport"] as? String
        long.text = dataPassed["longitudeAirport"] as? String
        timezone.text = dataPassed["timezone"] as? String
        gmt.text = dataPassed["GMT"] as? String
        country.text = dataPassed["nameCountry"] as? String
        
        // Do any additional setup after loading the view.
    }
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch map.selectedSegmentIndex
        {
        case 0:
            type = "Standard";
        case 1:
            type = "Satellite";
        case 2:
            type = "Hybrid";
        default:
            break;
        }
        performSegue(withIdentifier: "map", sender: self)
    }
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "map" {
            // Obtain the object reference of the destination view controller
            let detailViewController: MapViewController = segue.destination as! MapViewController
            detailViewController.mapType = type
            let t1 = lat.text as! String
            let t2 = long.text as! String
            let la = Double(t1)
            let longg = Double(t2)

            let tem = CLLocationCoordinate2D(latitude: la!, longitude: longg!)
            detailViewController.geo = tem
            detailViewController.titleD = name.text!
        }
        if segue.identifier == "Nearby" {
            let nearbyViewController: NearbyViewController = segue.destination as! NearbyViewController
            nearbyViewController.lat = self.lat.text!
            nearbyViewController.long = self.long.text!
        
            
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

}
