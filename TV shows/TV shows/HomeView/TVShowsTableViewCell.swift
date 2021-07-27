//
//  TVShowsTableViewCell.swift
//  TV shows
//
//  Created by infinum on 27.07.2021..
//

import UIKit

class TVShowsTableViewCell: UITableViewCell {

    @IBOutlet var showNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        showNameLabel.text = "awodihjoi"
        showNameLabel.textColor = .red
    }
}
