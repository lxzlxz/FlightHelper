//
//  CityTableViewController.swift
//  1
//
//  Created by yzn123 on 12/1/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController {


    //city name passed
    var cityName = ""
    //real time row number of table
    var rNum = 0;
    //table view
    @IBOutlet var topTableView: UITableView!
    
    //hold the array of dictionary of "results"
    var resultArray: [Dictionary<String, AnyObject>] = []
    
    //height of row
    let tableViewRowHeight: CGFloat = 80
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()

        //input validation
        if (cityName.isEmpty) {
            showAlertMessage(messageHeader: "Please enter something", messageBody: "No city name entered!")
            return
        }
        //doing json query and process it
        let nameQuery = "http://aviation-edge.com/v2/public/autocomplete?key=46c19e-b5b03b&city=" + cityName
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
                if (dictionaryOfJsonData["airportsByCities"] is NSNull) {
                    showAlertMessage(messageHeader: "Failed to read from API", messageBody: "No api data found!")
                    return
                }
                
                resultArray = dictionaryOfJsonData["airportsByCities"] as! [Dictionary<String, AnyObject>]
               
                
            }
            catch{
                showAlertMessage(messageHeader: "Failed to read from API", messageBody: "No api data found!")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultArray.count
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // top Cell, which was specified in the storyboard
        let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "search cell") as! SearchTableViewCell
        let airName = resultArray[rowNumber]["nameAirport"] as! String
        let airCode = resultArray[rowNumber]["codeIataAirport"] as! String
        cell.airportCode.text = airCode
        cell.airportName.text = airName
        
        
        
        return cell
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    
    
    //---------------------------
    // (Row) Selected
    //---------------------------
    
    // Tapping a row  displays data about the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        rNum = rowNumber
        performSegue(withIdentifier: "search detail", sender: self)
    }
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "search detail" {
            // Obtain the object reference of the destination view controller
            let detailViewController: detailViewController = segue.destination as! detailViewController
            detailViewController.dataPassed = resultArray[rNum]
            
        }
    }
   

}
