//
//  RootSearchViewController.swift
//  final
//
//  Created by Yifan Zhou on 2018/12/1.
//  Copyright © 2018年 Yifan Zhou. All rights reserved.
//

import UIKit


class RootSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    
    //
    var isShaked = false
    //input data
    var departureAirportTextField = ""
    var arrivalAirportTextField = ""
    
    // dictionary and keys
    var dict_flightNumber_data = Dictionary<String, [String]>()
    var flightNumber = [String]()
    
    //data to pass
    var airlineIataToPass = ""
    var flightNumberToPass = ""
    var depatureAirportToPass = ""
    var arrivalAirportToPass = ""
    var flightTimeToPass = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //switch the input
        if (isShaked) {
            toTextField.text! = arrivalAirportTextField
            fromTextField.text! = departureAirportTextField
            isShaked = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func searchButtontapped(_ sender: UIButton) {
        let from = fromTextField.text!
        let to = toTextField.text!
        searchQuery(arrival: to, depature: from)
    }
    
    
    func searchQuery(arrival: String, depature: String) {
        
        //clean dict_flightNumber_data and flightNumber
        dict_flightNumber_data = Dictionary<String, [String]>()
        flightNumber = [String]()
        
        //input data validation
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqresuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        if depature.isEmpty && arrival.isEmpty {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid IATA code of your airport!")
            return
        }
        
        if (depature.rangeOfCharacter(from: characterset.inverted) != nil) {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid IATA code of your depature airport!")
            return
        }
        
        if (arrival.rangeOfCharacter(from: characterset.inverted) != nil) {
            showAlertMessage(messageHeader: "Unrecognized Input", messageBody: "Please enter a valid IATA code of your arrival airport!")
            return
        }
        
        //parse
        let key = "46c19e-b5b03b"
        var apiUrl = ""
        
        //thress types of input
        if (arrival.isEmpty) {
            apiUrl = "http://aviation-edge.com/v2/public/routes?key=\(key)&departureIata=\(depature)"
        } else if (depature.isEmpty){
            apiUrl = "http://aviation-edge.com/v2/public/routes?key=\(key)&arrivalIata=\(arrival)"
        } else if (arrival.isEmpty && depature.isEmpty){
            showAlertMessage(messageHeader: "Enter the IATA code of airport", messageBody: "Enter the IATA code of airport")
            return
        } else {
            apiUrl = "http://aviation-edge.com/v2/public/routes?key=\(key)&departureIata=\(depature)&arrivalIata=\(arrival)"
        }
        
        //get data from url
        let url = URL(string: apiUrl)
        let jsonData: Data?
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            return
        }
        
        
        if let jsonDataFromApiUrl = jsonData {
            do {
                /*
                 Parse The Data
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                
                // Typecast the returned NSDictionary as [Dictionary<String, AnyObject>]
                var dictionaryOfJsonData = [Dictionary<String, AnyObject>]()
                if let temp = jsonDataDictionary as? [Dictionary<String, AnyObject>] {
                    dictionaryOfJsonData = temp
                } else {
                    showAlertMessage(messageHeader: "Can't find route", messageBody: "Maybe the IATA code of your airport is wrong, or this route doesn't exist")
                    return
                }
                
                
                //read json data and get the information of route
                for dict in dictionaryOfJsonData {
                    var flightNumber = ""
                    
                    var departureAirport = ""
                    var arrivalAirport = ""
                    var departureTime = ""
                    var arrivalTime = ""
                    var airlineIata = ""
                    
                    if let  temp = dict["departureIata"] as? String {
                        departureAirport = temp
                    }
                    if let temp = dict["arrivalIata"] as? String {
                        arrivalAirport = temp
                    }
                    if let temp = dict["departureTime"] as? String {
                        departureTime = temp
                    }
                    if let temp = dict["arrivalTime"] as? String {
                        arrivalTime = temp
                    }
                    
                    if let temp = dict["airlineIata"] as? String {
                        airlineIata = temp
                    }
                    
                    if let temp = dict["flightNumber"] as? String {
                        flightNumber = temp
                    }
                    
                    //put into dict
                    if (!flightNumber.isEmpty) {
                        dict_flightNumber_data[airlineIata+flightNumber] = [departureAirport, arrivalAirport, departureTime, arrivalTime, airlineIata]
                        self.flightNumber.append(airlineIata+flightNumber)
                    }
                }
                
                tableView.reloadData()
                
            } catch _ as NSError {
                return
            }
        } else {
            return
        }
    }
    
    
    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    //set section number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //set row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightNumber.count
    }
    
    //set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search Result", for: indexPath) as! RouteTableViewCell
        
        //get data from dict
        let id = flightNumber[rowNumber]
        let data = dict_flightNumber_data[id]
        
        //assign data to cell
        cell.titleLabel.text = "From " + data![0] + " To " + data![1] + "    " + id
        cell.detailLabel.text = "Departure at: " + data![2] + " Arrival at: " + data![3]
        
        
        return cell
    }
    

   

    //---------------------------
    //  Row Selected
    //---------------------------
    
    // Tapping a row displays data about the selected country
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flightTimeToPass = [String]()
        let rowNumber = (indexPath as NSIndexPath).row
        
        //dict_flightNumber_data[flightNumber!] = [departureAirport, arrivalAirport, departureTime, arrivalTime, airlineIata]
        flightNumberToPass = self.flightNumber[rowNumber]
        airlineIataToPass = dict_flightNumber_data[flightNumberToPass]![4]
        depatureAirportToPass = dict_flightNumber_data[flightNumberToPass]![0]
        arrivalAirportToPass = dict_flightNumber_data[flightNumberToPass]![1]
        
        let id = self.flightNumber[rowNumber]
        let data = dict_flightNumber_data[id]
        
        
        flightTimeToPass.append(data![2])
        flightTimeToPass.append(data![3])
        performSegue(withIdentifier: "Search Detail", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Search Detail" {
            
            // Obtain the object reference of the destination view controller
            let routeSearchDetailViewController: RouteSearchDetailViewController = segue.destination as! RouteSearchDetailViewController
            
            // Pass the data object to the downstream view controller object
            routeSearchDetailViewController.airlineIata = airlineIataToPass
            routeSearchDetailViewController.flightNumber = flightNumberToPass
            routeSearchDetailViewController.depatureAirport = depatureAirportToPass
            routeSearchDetailViewController.arrivalAirport = arrivalAirportToPass
            routeSearchDetailViewController.flightTimeGet = flightTimeToPass
            
            //back button
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    /*
     -----------------------------------
     MARK: - Switch on Shake Gesture
     -----------------------------------
     */
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        // If the detected motion is a Shake Gesture
        if event!.subtype == UIEvent.EventSubtype.motionShake {
            departureAirportTextField = toTextField.text!
            arrivalAirportTextField = fromTextField.text!
            isShaked = true
            viewWillAppear(true)
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
     -----------------------------------
     MARK: - Keyboard
     -----------------------------------
     */
    
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        sender.resignFirstResponder()
    }
    
    
    
}
