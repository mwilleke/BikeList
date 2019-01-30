//
//  NetworkTableViewCell.swift
//  BikeList
//
//  Created by Matthew Willeke on 1/27/19.
//  Copyright © 2019 Matthew Willeke. All rights reserved.
//

import UIKit

class NetworkTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
