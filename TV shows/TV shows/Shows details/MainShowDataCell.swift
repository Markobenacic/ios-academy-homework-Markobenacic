//
//  MainShowDataCell.swift
//  TV shows
//
//  Created by infinum on 28.07.2021..
//

import UIKit

class MainShowDataCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet var showImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var reviewsAverageLabel: UILabel!
    @IBOutlet var star1ImageView: UIImageView!
    @IBOutlet var star2ImageView: UIImageView!
    @IBOutlet var star3ImageView: UIImageView!
    @IBOutlet var star4ImageView: UIImageView!
    @IBOutlet var star5ImageView: UIImageView!
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Class methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        
    }

}


// MARK: - Configure
extension MainShowDataCell {
    func configure(show: Show, reviews: [Review] ) {
        descriptionLabel.text = show.description
        let numberOfReviews = reviews.count
        
        // calc average, dumb way
        var sum = 0
        for review in reviews {
            sum += review.rating
        }
        let average = Double(sum) / Double(numberOfReviews)
        
        //to write review or review(s) properly
        let multipleSuffix = numberOfReviews == 1 ? "" : "s"
        
        reviewsAverageLabel.text = String(numberOfReviews) + " review" + multipleSuffix + ", " + String(average) + " average"
        
        star1ImageView.image = average < 0.5 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star2ImageView.image = average < 1.5 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star3ImageView.image = average < 2.5 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star4ImageView.image = average < 3.5 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        star5ImageView.image = average < 4.5 ? UIImage(named: "ic-star-deselected") : UIImage(named: "ic-star-selected")
        
    }

}