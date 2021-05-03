//
//  SearchTableViewCell.swift
//  1
//
//  Created by yzn123 on 12/1/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    //airport name
    @IBOutlet var airportName: UILabel!
    //airport code
    @IBOutlet var airportCode: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
