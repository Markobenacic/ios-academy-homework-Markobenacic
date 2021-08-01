//
//  TVShowsTableViewCell.swift
//  TV shows
//
//  Created by infinum on 27.07.2021..
//

import UIKit
import Kingfisher

class TVShowsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var showNameLabel: UILabel!
    @IBOutlet var showImageView: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showImageView.layer.cornerRadius = 8.0
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
        showImageView.kf.setImage(
            with: item.imageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-rectangle"))
        
    }
}
