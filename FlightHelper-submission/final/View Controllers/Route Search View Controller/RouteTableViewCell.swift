//
//  RouteTableViewCell.swift
//  final
//
//  Created by Yifan Zhou on 2018/12/1.
//  Copyright © 2018年 Yifan Zhou. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
