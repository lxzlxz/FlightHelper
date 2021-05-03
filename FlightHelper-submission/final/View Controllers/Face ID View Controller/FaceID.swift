//
//  MyFavouriteTableViewController.swift
//  final
//
//  Created by Yifan Zhou on 2018/12/4.
//  Copyright © 2018年 Yifan Zhou, Xingzhang Li. All rights reserved.
//


//This framework contains authentication helper codes
import LocalAuthentication
import UIKit


class FaceID: UIViewController {
    
    
    var alreadySuccessed = false
    @IBOutlet var alertLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        alertLabel.text! = ""
        //user don't neeed to use faceID/TouchID if he/she already authenticated
        if (alreadySuccessed == false) {
            alertLabel.text! = "To see your favourite flight route, you need to use FaceID/TouchID to varify your identity. If you deny the FaceID/TouchID, Please Go To iPhone Setting->FaceID/TouchID->Other Application to enable the FaceID/TouchID functionality"

            touchIdAction()
        } else {
            self.performSegue(withIdentifier: "success", sender: self)
        }
    }
    
    func touchIdAction() {
        let myContext = LAContext()
        let myLocalizedReasonString = "Local Biometric Authentication"
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            self.alreadySuccessed = true
                            self.performSegue(withIdentifier: "success", sender: self)
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                
                
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "success") {
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
