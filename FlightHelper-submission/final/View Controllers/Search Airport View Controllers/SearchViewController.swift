//
//  SearchViewController.swift
//  1
//
//  Created by yzn123 on 12/1/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    //text field that user enters city name to get airports within that city.
    @IBOutlet var textInput: UITextField!
    //search button touched
    @IBAction func Search(_ sender: UIButton) {
        self.performSegue(withIdentifier: "search city", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //remove keyboard
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        
        sender.resignFirstResponder()
        
    }

    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "search city" {
            // Obtain the object reference of the destination view controller
            let detailViewController: CityTableViewController = segue.destination as! CityTableViewController
            detailViewController.cityName = textInput.text!
            
        }
    }

}
