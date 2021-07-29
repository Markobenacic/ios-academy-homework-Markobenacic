//
//  CommentCell.swift
//  TV shows
//
//  Created by infinum on 28.07.2021..
//

import UIKit

class CommentCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var rating: Int?
    
    // MARK: - Outlets
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var star1ImageView: UIImageView!
    @IBOutlet var star2ImageView: UIImageView!
    @IBOutlet var star3ImageView: UIImageView!
    @IBOutlet var star4ImageView: UIImageView!
    @IBOutlet var star5ImageView: UIImageView!
    
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Class methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = UIImage(named: "ic-profile-placeholder")
        userEmailLabel.text = "jane.doe@infinum.com"
        descriptionLabel.text = ""
        
    }
    
}

// MARK: - Configure

extension CommentCell {
    
    func configure(with item: Review) {
        //missing: user image
        
        self.rating = item.rating
        userEmailLabel.text = item.user.email
        descriptionLabel.text = item.comment
        
        star1ImageView.image = item.rating <= 1 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star2ImageView.image = item.rating <= 2 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star3ImageView.image = item.rating <= 3 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star4ImageView.image = item.rating <= 4 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star5ImageView.image = item.rating <= 5 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
    }
}
