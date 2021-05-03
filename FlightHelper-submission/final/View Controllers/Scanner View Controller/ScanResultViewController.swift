//
//  ScanResultViewController.swift
//  1
//
//  Created by yzn123 on 12/4/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit

class ScanResultViewController: UIViewController {
    //text view to display scaned result
    @IBOutlet var text: UITextView!
    //tem result
    var tem = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        text.text = tem

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

}
