//
//  NearbyViewController.swift
//  1
//
//  Created by yzn123 on 12/2/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit
import MapKit

class NearbyViewController: UIViewController {
    //lat
    var lat = ""
    //long
    var long = ""
    //pick the nearby types
    @IBOutlet var picker: UIPickerView!
    
    //radius
    @IBOutlet var radius: UILabel!
    let typeGenre = ["jewelry_store", "library", "atm", "restaurant", "bank", "bar", "cafe", "police", "hospital", "zoo"]
    //move the slider to choose the radius
    @IBAction func slider(_ sender: UISlider) {
        
    
        /*
         
         The sender's value, i.e., slider's value, is a floating-point value.
         
         Floating-point values are always truncated when used to initialize a new integer value.
         
         Therefore, we add 0.5 to round the value to the nearest integer value.
         
         */
        
        
        
        let sliderIntValue = Int(sender.value + 0.5)    // Conversion from Float to Integer
        
        
        
        /*
         
         Slider's integer value is converted into a String value.
         
         The String value is assigned to be the slider's label text.
         
         */
        
        
        
        radius.text = String(sliderIntValue)
    }
    
    //show the facilities among the radius of the "picked" type
    @IBAction func Show(_ sender: UIButton) {
        self.performSegue(withIdentifier: "type show", sender: self)
    }
    //picked type. Such as restaurants, atms.
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let numberOfType = typeGenre.count
        let numberOfRow = Int(numberOfType / 2)
        picker.selectRow(numberOfRow, inComponent: 0, animated: false)
        type = typeGenre[numberOfRow]
        picker.delegate = self
        
        //
    }
    

    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "type show" {
            // Obtain the object reference of the destination view controller
            let tMapViewController: typeMapViewController = segue.destination as! typeMapViewController
            tMapViewController.type = self.type
            tMapViewController.long = self.long
            tMapViewController.lat = self.lat
            tMapViewController.radius = self.radius.text!
            
        }
    }

}
extension NearbyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = typeGenre[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeGenre[row]
    }
    
    
    
}

