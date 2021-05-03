//
//  MyFavouriteTableViewController.swift
//  final
//
//  Created by Yifan Zhou on 2018/12/4.
//  Copyright © 2018年 Yifan Zhou. All rights reserved.
//

import UIKit

class MyFavouriteTableViewController: UITableViewController {

    @IBOutlet var MyFavouriteTableView: UITableView!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //---------- Create and Initialize the Arrays -----------------------
    
    var flightNumber = [String]()
    
    // dataObjectToPass is the data object to pass to the downstream view controller
    var dataObjectToPass: [String] = []
    var flightNumberToPass = ""
    
    //reload the table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.setHidesBackButton(true, animated:true);
        flightNumber = applicationDelegate.dict_flightNumber_routeData.allKeys as! [String]
        self.tableView.reloadData()
    }
    
    //load data
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide back button
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        flightNumber = applicationDelegate.dict_flightNumber_routeData.allKeys as! [String]
        
    }

    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    // We are implementing a Grouped table view style as we selected in the storyboard file.
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------
    
    // Each table view section corresponds to a country
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    // Return Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return flightNumber.count
        } else {
            return 0
        }
    }
    
    //-----------------------------
    // Set Title for Section Header
    //-----------------------------
    
    // Set the table view section header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        if section == 0 {
            return "Favourite Route"
        }
        return "Favourite Airport"
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "My Favourite Cell", for: indexPath) as UITableViewCell
        
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        if sectionNumber == 0 {
            cell.textLabel!.text = flightNumber[rowNumber]
        }
        
        return cell
    }
    
    //-------------------------------
    // Allow Editing of Rows
    //-------------------------------
    
    // We allow each row  of the table view to be editable, i.e., deletable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
    // This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {   // Handle the Delete action
            
            let rowNumber = (indexPath as NSIndexPath).row
            
            // Obtain the name of the To Do Item
            let selectedFlight = flightNumber[rowNumber]
            //let sectionNumber = (indexPath as NSIndexPath).section
           
            //if sectionNumber == 0 {
            applicationDelegate.dict_flightNumber_routeData.removeObject(forKey: selectedFlight)
            
            flightNumber = applicationDelegate.dict_flightNumber_routeData.allKeys as! [String]
            
            // Reload the Table View
            viewWillAppear(true)
        }
    }
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    //---------------------------
    //  Row Selected
    //---------------------------
    
    // Tapping a row  displays data about the selected Video
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        let sectionNumber = (indexPath as NSIndexPath).section
        
        // Obtain the flight number
        if sectionNumber == 0 {
            let selectedFlight = flightNumber[rowNumber]
            flightNumberToPass = selectedFlight
            dataObjectToPass = applicationDelegate.dict_flightNumber_routeData[selectedFlight] as! [String]
            
            performSegue(withIdentifier: "Route Detail", sender: self)
        }
    }

    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "Route Detail" {
            // Obtain the object reference of the destination view controller
            let routeDetailViewController: RouteDetailViewController = segue.destination as! RouteDetailViewController
            
            // Pass the data object to the downstream view controller object
            routeDetailViewController.dataFromUpStream = dataObjectToPass
            routeDetailViewController.flightNumber = flightNumberToPass
        }
    }
}
