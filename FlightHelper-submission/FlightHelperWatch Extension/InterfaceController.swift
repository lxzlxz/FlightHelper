//
//  InterfaceController.swift
//  watch Extension
//
//  Created by yzn123 on 12/4/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import WatchKit
import Foundation
import UIKit

class InterfaceController: WKInterfaceController {
    // Create and initialize the dictionary to store the input data
    var dict_FlightNumber_FlightData = [String: AnyObject]()
    @IBOutlet var table: WKInterfaceTable!

    var ttem = [String]()
    var flightNumber = [String]()
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTable() {
        /*******************************************
         * Read in the RouteILike.plists file content
         *******************************************/
        
        // Obtain the file path to the plist file. mainBundle refers to your project module.
        let automobilesFilePath: NSString? = Bundle.main.path(forResource: "RouteILike", ofType: "plist") as NSString?
        
        // Instantiate an NSDictionary object and initialize it with the contents of the Automobiles.plist file.
        let dictionaryFromFile: NSDictionary? = NSDictionary(contentsOfFile: automobilesFilePath! as String)
        
        if let dictionaryForAutomobilesPlistFile = dictionaryFromFile {
            
            // Typecast the created dictionary of type NSDictionary as Dictionary type
            // and assign it to the class property named dict_FlightNumber_FlightData
            dict_FlightNumber_FlightData = dictionaryForAutomobilesPlistFile as! Dictionary
            
            /*
             allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
             Therefore, typecast the AnyObject type keys to be of type String.
             The keys in the array are *unordered*; therefore, they need to be sorted.
             */
            flightNumber = dictionaryForAutomobilesPlistFile.allKeys as! [String]

            // Sort the auto manufacturer names within itself in alphabetical order
            flightNumber.sort { $0 < $1 }
            
            
        } else {
             print("Json failed, No api processed!")

            return
        }
        if (dict_FlightNumber_FlightData.count != 0) {
        self.table.setNumberOfRows(dict_FlightNumber_FlightData.count, withRowType: "FlightRow")
        for i in 0...(dict_FlightNumber_FlightData.count - 1) {
        
        
        let row = self.table.rowController(at: i) as! Table
    
        let tem = Array(dict_FlightNumber_FlightData)[i].key
        row.name.setText(tem)
        ttem.append(tem)
            
    
        }
        }

    }
    
    
    override init() {
        super.init()
        
        loadTable()
    }
    
}
