//
//  LanguagePickerViewController.swift
//  1
//
//  Created by yzn123 on 12/4/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit

class LanguagePickerViewController: UIViewController {
    //picker a language translate from
    @IBOutlet var from: UIPickerView!
    
    //pick a language translate to
    @IBOutlet var to: UIPickerView!
    //after picker views are selceted, go to translate page
    @IBAction func GoNext(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "translator", sender: self)
        
    }
    //hard-coded supporting languages by locale
    let languageDictionary = ["Malayalam" : "ml",
                              "English" : "en",
                              "Arabic" : "ar",
                              "Armenian" : "hy",
                              "Afrikaans" : "af",
                              "Basque" : "eu",
                              "German" : "de",
                              "Bulgarian" : "bg",
                              "Persian" : "fa",
                              "Polish" : "pl",
                              "Welsh" : "cy",
                              "Portuguese" : "pt",
                              "Hungarian" : "hu",
                              "Romanian" : "ro",
                              "Vietnamese" : "vi",
                              "Russian" : "ru",
                              "Greek" : "el",
                              "Thai" : "th",
                              "Indonesian" : "id",
                              "Italian" : "it",
                              "Turkish" : "tr",
                              "Spanish" : "es",
                              "Chinese" : "zh",
                              "French" : "fr",
                              "Korean" : "ko",
                              "Hindi" : "hi",
                              "Swedish" : "sv",
                              "Japanese" : "ja"]
    //the languages names
    var pickerName = [String]()
    //the type from
    var typeF = "Japanese"
    //type to
    var typeT = "Japanese"
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...(languageDictionary.count - 1) {
            pickerName.append(Array(languageDictionary)[i].key)
        }
        pickerName.sort { $0 < $1 }
        // fore ground picker view
        from.dataSource = self
        from.delegate = self
        from.selectRow(pickerName.count/2, inComponent:0, animated:true)
        to.dataSource = self
        to.delegate = self
        to.selectRow(pickerName.count/2, inComponent:0, animated:true)
        
        
        

        // Do any additional setup after loading the view.
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
     ---------------------------
     
     MARK: - go to segue
     
     ---------------------------
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "translator" {
            let destController: TranslatorViewController = segue.destination as! TranslatorViewController
            destController.typeF = self.typeF
            destController.typeT = self.typeT
        }
    }

}
extension LanguagePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == from {
            return pickerName.count
        }
        else if pickerView == to {
            return pickerName.count
        }
        else {
            return -1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == from {
            typeF = pickerName[row]
        }
        else if pickerView == to {
            typeT = pickerName[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == from {
            return pickerName[row]
        }
        else if pickerView == to {
            return pickerName[row]
        }
        else {
            return nil
        }
        
    }
    
    
    
}

