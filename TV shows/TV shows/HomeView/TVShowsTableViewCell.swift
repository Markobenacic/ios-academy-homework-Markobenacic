//
//  TVShowsTableViewCell.swift
//  TV shows
//
//  Created by infinum on 27.07.2021..
//

import UIKit

class TVShowsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var showNameLabel: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Class methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showNameLabel.text = nil
    }
}

// MARK: - Configure

extension TVShowsTableViewCell {
    
    func configure(with item: Show) {
        showNameLabel.text = item.title
    }
}
