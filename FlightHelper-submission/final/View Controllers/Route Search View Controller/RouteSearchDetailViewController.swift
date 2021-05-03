//
//  RouteSearchDetailViewController.swift
//  final
//
//  Created by Yifan Zhou on 2018/12/2.
//  Copyright © 2018年 Yifan Zhou. All rights reserved.
//

import UIKit
import MapKit

class RouteSearchDetailViewController: UIViewController {

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let key = "46c19e-b5b03b"
    
    //data from previous controller
    var airlineIata = ""
    var flightNumber = ""
    
    var depatureAirport = ""
    var arrivalAirport = ""
    
    //[0] = depature time
    //[1] = arrival time
    var flightTimeGet = [String]()
    
    //data to pass
    //geography[0] = latitude
    //geography[1] = longitude
    var geography = [Double]()
    var arrivalAirportGeo = [Double]()
    var depatureAirportGeo = [Double]()
    
    //data to display
    var status = "N/A"
    //"nameAirport":"Roanoke Regional Airport",
    //"timezone":"America/New_York",
    //"GMT":"-5",
    //"nameCountry":"United States",
    var arrivalAirportData:[String] = []
    var depatureAirportData:[String] = []
    
    //IBOutlet
  
    @IBOutlet var depatureAirportNameLabel: UILabel!
    @IBOutlet var depatureAirportTimeZoneLabel: UILabel!
    
    @IBOutlet var barButtonItem: UIBarButtonItem!
    
    @IBOutlet var DepatureGMTLabel: UILabel!
    
    @IBOutlet var arrivalAirportNameLabel: UILabel!
    
    @IBOutlet var arrivalAirportTimeZoneLabel: UILabel!
    
    @IBOutlet var arrivalGMTLabel: UILabel!
    
    @IBOutlet var flightStatusLabel: UILabel!
    
    @IBOutlet var flightTimeLabel: UILabel!
    
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        //save route data to plist
        var value = [String]()
        value.append(depatureAirport)
        value.append(arrivalAirport)
        value.append(depatureAirportData[0]) //airport name
        value.append(depatureAirportData[3]) //country name
        value.append(depatureAirportData[1]) //time zone
        value.append(depatureAirportData[2]) // GMT
        value.append(arrivalAirportData[0])
        value.append(arrivalAirportData[3])
        value.append(arrivalAirportData[1])
        value.append(arrivalAirportData[2])
        value.append(status)
        value.append(flightTimeGet[0]) 
        value.append(flightTimeGet[1])
        if geography.isEmpty {
            value.append("")
            value.append("")
        } else {
            value.append(String(format:"%f", geography[0]))
            value.append(String(format:"%f", geography[1]))
        }
        if arrivalAirportGeo.isEmpty {
            value.append("")
            value.append("")
        } else {
            value.append(String(format:"%f", arrivalAirportGeo[0]))
            value.append(String(format:"%f", arrivalAirportGeo[1]))
        }
        if depatureAirportGeo.isEmpty {
            value.append("")
            value.append("")
        } else {
            value.append(String(format:"%f", depatureAirportGeo[0]))
            value.append(String(format:"%f", depatureAirportGeo[1]))
        }
        
        //set key value pair
        applicationDelegate.dict_flightNumber_routeData.setObject(value, forKey: flightNumber as NSCopying)
        
        //save to plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/RouteILike.plist"
        applicationDelegate.dict_flightNumber_routeData.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up button
        let mapButton: UIBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(RouteSearchDetailViewController.mapButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = mapButton
        
        // API
        searchQuery(airlineIata: airlineIata, flightNumber: flightNumber)
        arrivalAirportGeo = searchAirport(airportCode: arrivalAirport, isArrival: true)
        depatureAirportGeo = searchAirport(airportCode: depatureAirport, isArrival: false )
        
        //"nameAirport":"Roanoke Regional Airport",
        //"timezone":"America/New_York",
        //"GMT":"-5",
        //"nameCountry":"United States",
        //var arrivalAirportData:[String] = []
        depatureAirportNameLabel.text! = depatureAirportData[0] + ", " + depatureAirportData[3]
        depatureAirportTimeZoneLabel.text! = "Time Zone: " + depatureAirportData[1]
        DepatureGMTLabel.text! = "GMT: " + depatureAirportData[2]
        
        arrivalAirportNameLabel.text! = arrivalAirportData[0] + ", " + arrivalAirportData[3]
        arrivalAirportTimeZoneLabel.text! = "Time Zone: " + arrivalAirportData[1]
        arrivalGMTLabel.text! = "GMT: " + arrivalAirportData[2]
        flightStatusLabel.text! = "Flight Status: " + status
        if (flightTimeGet[0].isEmpty || flightTimeGet.isEmpty) {
            flightTimeLabel.text! = "Flight Time Not Available"
        } else {
            flightTimeLabel.text! = flightTimeGet[0] + " - " + flightTimeGet[1]
        }
        
        //
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
    
    func searchAirport(airportCode:String, isArrival: Bool) -> [Double]{
        //https://aviation-edge.com/v2/public/airportDatabase?key=46c19e-b5b03b&codeIataAirport=ROA
        /*
         [
         {
         "airportId":"6788",
         "nameAirport":"Roanoke Regional Airport",
         "codeIataAirport":"ROA",
         "codeIcaoAirport":"KROA",
         "nameTranslations":"Roanoke,Roanoke Regional Airport,Roanoke,Roanoke,Roanoke,??????????????,??????",
         "latitudeAirport":"37.32051",
         "longitudeAirport":"-79.97038",
         "geonameId":"4782228",
         "timezone":"America/New_York",
         "GMT":"-5",
         "phone":"",
         "nameCountry":"United States",
         "codeIso2Country":"US",
         "codeIataCity":"ROA"
         }
         ]
         */
        let apiUrl = "https://aviation-edge.com/v2/public/airportDatabase?key=\(key)&codeIataAirport=\(airportCode)"
        
        let url = URL(string: apiUrl)
        let jsonData: Data?
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            showAlertMessage(messageHeader: "API returns Null", messageBody: "Please Contact the developer")
            return []
        }
        
        if let jsonDataFromApiUrl = jsonData {
            do {
                
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                
                var dictionaryOfJsonData = [Dictionary<String, AnyObject>]()
                if let temp = jsonDataDictionary as? [Dictionary<String, AnyObject>] {
                    dictionaryOfJsonData = temp
                } else {
                    return []
                }
                
                let airportData = dictionaryOfJsonData[0]
                var latitudeAirport = Double()
                var longitudeAirport = Double()
                if let temp = airportData["latitudeAirport"] as? String {
                    latitudeAirport = Double(temp)!
                }
                if let temp = airportData["longitudeAirport"] as? String {
                    longitudeAirport = Double(temp)!
                }
                //"nameAirport":"Roanoke Regional Airport",
                //"timezone":"America/New_York",
                //"GMT":"-5",
                //"nameCountry":"United States",
                var airportInfo : [String] = []
                
                
                if let temp = airportData["nameAirport"] as? String {
                    airportInfo.append(temp)
                }
                
                if let temp = airportData["timezone"] as? String {
                    airportInfo.append(temp)
                }
                
                if let temp = airportData["GMT"] as? String {
                    airportInfo.append(temp)
                }
                if let temp = airportData["nameCountry"] as? String {
                    airportInfo.append(temp)
                }
                
                if isArrival {
                    arrivalAirportData = airportInfo
                } else {
                    depatureAirportData = airportInfo
                }
                return [latitudeAirport, longitudeAirport]
                
            } catch _ as NSError {
                return []
            }
        } else {
            return []
        }
        
    }
    
    func searchQuery(airlineIata: String, flightNumber: String) {
        //http://aviation-edge.com/v2/public/flights?key=dd3120-748b4c&limit=30000&flightNum=4731&airlineIata=AA
        
        let apiUrl = "http://aviation-edge.com/v2/public/flights?key=\(key)&limit=30000&flightNum=\(flightNumber)&airlineIata=\(airlineIata)"
        
        let url = URL(string: apiUrl)
        let jsonData: Data?
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            showAlertMessage(messageHeader: "API returns Null", messageBody: "Please Contact the developer")
            return
        }
        
        if let jsonDataFromApiUrl = jsonData {
            do {
                /*
                 [
                 {
                 "geography":{
                 "latitude":38.6106,
                 "longitude":-80.3949,
                 "altitude":8534.4,
                 "direction":246
                 },
                 "speed":{
                 "horizontal":613.012,
                 "isGround":0,
                 "vertical":0
                 },
                 "departure":{
                 "iataCode":"PHL",
                 "icaoCode":"KPHL"
                 },
                 "arrival":{
                 "iataCode":"BNA",
                 "icaoCode":"KBNA"
                 },
                 "aircraft":{
                 "regNumber":"N125HQ",
                 "icaoCode":"E75S",
                 "icao24":"A06703",
                 "iataCode":"E75S"
                 },
                 "airline":{
                 "iataCode":"AA",
                 "icaoCode":"AAL"
                 },
                 "flight":{
                 "iataNumber":"AA4731",
                 "icaoNumber":"AAL4731",
                 "number":"4731"
                 },
                 "system":{
                 "updated":"1543778341",
                 "squawk":"1532"
                 },
                 "status":"en-route"
                 }
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                
                var dictionaryOfJsonData = [Dictionary<String, AnyObject>]()
                if let temp = jsonDataDictionary as? [Dictionary<String, AnyObject>] {
                    dictionaryOfJsonData = temp
                } else {
                    
                    return
                }
                
                //get longitude & latitude & status
                let airplaneData = dictionaryOfJsonData[0]
                if let temp = airplaneData["status"] as? String {
                    status = temp
                }
                
                if let temp = airplaneData["geography"] as? Dictionary<String, Double> {
                    if temp["latitude"] != nil {
                        geography.append(temp["latitude"]!)
                    }
                    if temp["longitude"] != nil {
                        geography.append(temp["longitude"]!)
                    }
                }
                
                if !geography.isEmpty {
                    viewWillAppear(true)
                }
                
                
                
                
            } catch _ as NSError {
                return
            }
        } else {
            return
        }
        
    }

    //---------------------------
    //  Map Tapped
    //---------------------------
    
    
    
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Route Map", sender: self)
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Route Map", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Route Map" {
            
            // Obtain the object reference of the destination view controller
            let routeMapViewController: RouteMapViewController = segue.destination as! RouteMapViewController
            
            // Pass the data object to the downstream view controller object
            //geography[0] = latitude
            //geography[1] = longitude
            routeMapViewController.airplaneGeoArray = geography
            routeMapViewController.arrivalAirportGeoArray = arrivalAirportGeo
            routeMapViewController.depatureAirportGeoArray = depatureAirportGeo
            
            
            //back button
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
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
    
}
