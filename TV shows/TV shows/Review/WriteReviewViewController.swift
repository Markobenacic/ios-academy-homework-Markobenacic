//
//  WriteReviewViewController.swift
//  TV shows
//
//  Created by infinum on 29.07.2021..
//

import UIKit

class WriteReviewViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var ratingView: RatingView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Actions
    
    // MARK: - Class methods

    private func setupUI() {
        setupBackButton()
        title = "Write a review"
        submitButton.layer.cornerRadius = 20.0
    }
    
}

//MARK: - private UI setup

private extension WriteReviewViewController {
    
    func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
        )
    }
    
    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }

}
