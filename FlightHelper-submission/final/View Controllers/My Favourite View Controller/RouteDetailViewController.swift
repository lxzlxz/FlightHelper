//
//  RouteDetailViewController.swift
//  final
//
//  Created by Yifan Zhou on 2018/12/4.
//  Copyright © 2018年 Yifan Zhou. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController {

    
    @IBOutlet var depatureAirportNameLabel: UILabel!
    @IBOutlet var depatureAirportTimeZoneLabel: UILabel!
    
    @IBOutlet var barButtonItem: UIBarButtonItem!
    
    @IBOutlet var DepatureGMTLabel: UILabel!
    
    @IBOutlet var arrivalAirportNameLabel: UILabel!
    
    @IBOutlet var arrivalAirportTimeZoneLabel: UILabel!
    
    @IBOutlet var arrivalGMTLabel: UILabel!
    
    @IBOutlet var flightStatusLabel: UILabel!
    
    @IBOutlet var flightTimeLabel: UILabel!
    
    
    var dataFromUpStream = [String]()
    var flightNumber = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up map button
        let mapButton: UIBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(RouteDetailViewController.mapButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = mapButton
        
        /*
         dataFromUpStream:
         0.value.append(depatureAirport)
         1. value.append(arrivalAirport)
         2. value.append(depatureAirportData[0]) //airport name
         3. value.append(depatureAirportData[3]) //country name
         4. value.append(depatureAirportData[1]) //time zone
         5. value.append(depatureAirportData[2]) // GMT
         6. value.append(arrivalAirportData[0])
         7. value.append(arrivalAirportData[3])
         8. value.append(arrivalAirportData[1])
         9. value.append(arrivalAirportData[2])
         10. value.append(status)
         11. value.append(flightTimeGet[0])
         12. value.append(flightTimeGet[1])
         if geography.isEmpty {
         value.append("")
         value.append("")
         } else {
         13. value.append(String(format:"%f", geography[0]))
         14. value.append(String(format:"%f", geography[1]))
         }
         if arrivalAirportGeo.isEmpty {
         value.append("")
         value.append("")
         } else {
         15. value.append(String(format:"%f", arrivalAirportGeo[0]))
         16. value.append(String(format:"%f", arrivalAirportGeo[1]))
         }
         if depatureAirportGeo.isEmpty {
         value.append("")
         value.append("")
         } else {
         17. value.append(String(format:"%f", depatureAirportGeo[0]))
         18. value.append(String(format:"%f", depatureAirportGeo[0]))
         }
         */
        
        depatureAirportNameLabel.text! = dataFromUpStream[2] + ", " + dataFromUpStream[3]
        depatureAirportTimeZoneLabel.text! = "Time Zone: " + dataFromUpStream[4]
        DepatureGMTLabel.text! = "GMT: " + dataFromUpStream[5]
        
        arrivalAirportNameLabel.text! = dataFromUpStream[6] + ", " + dataFromUpStream[7]
        arrivalAirportTimeZoneLabel.text! = "Time Zone: " + dataFromUpStream[8]
        arrivalGMTLabel.text! = "GMT: " + dataFromUpStream[9]
        
        flightStatusLabel.text! = "Flight Status: " + dataFromUpStream[10]
        if dataFromUpStream[11].isEmpty || dataFromUpStream[12].isEmpty{
            flightTimeLabel.text! =  "Flight Time Not Available"
        } else {
            flightTimeLabel.text! = "Flight Time: " + dataFromUpStream[11] + " - " + dataFromUpStream[12]
        }
        
        //title
        let navigationBarWidth = self.navigationController?.navigationBar.frame.width
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let labelRect = CGRect(x: 0, y: 0, width: navigationBarWidth!, height: navigationBarHeight!)
        let titleLabel = UILabel(frame: labelRect)
        
        titleLabel.text = flightNumber
        
        titleLabel.font = titleLabel.font.withSize(17)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
    }
    

    //---------------------------
    //  Map Tapped
    //---------------------------
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Route Map In Favourite", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Route Map In Favourite" {
            
            // Obtain the object reference of the destination view controller
            let routeMapViewController: RouteMapViewController = segue.destination as! RouteMapViewController
            
            // Pass the data object to the downstream view controller object
            /*
            13. value.append(String(format:"%f", geography[0]))
            14. value.append(String(format:"%f", geography[1]))
            }
            if arrivalAirportGeo.isEmpty {
                 value.append("")
                 value.append("")
            } else {
                15. value.append(String(format:"%f", arrivalAirportGeo[0]))
                16. value.append(String(format:"%f", arrivalAirportGeo[1]))
            }
            if depatureAirportGeo.isEmpty {
                value.append("")
                value.append("")
            } else {
                17. value.append(String(format:"%f", depatureAirportGeo[0]))
                18. value.append(String(format:"%f", depatureAirportGeo[0]))
            }
            */
            if !dataFromUpStream[13].isEmpty {
                routeMapViewController.airplaneGeoArray = [Double(dataFromUpStream[13]), Double(dataFromUpStream[14])] as! [Double]
            }
            routeMapViewController.arrivalAirportGeoArray = [Double(dataFromUpStream[15]), Double(dataFromUpStream[16])] as! [Double]
            routeMapViewController.depatureAirportGeoArray = [Double(dataFromUpStream[17]), Double(dataFromUpStream[18])] as! [Double]
            
            
        }
    }

}
