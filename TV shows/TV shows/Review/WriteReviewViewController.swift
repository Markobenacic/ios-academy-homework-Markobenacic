//
//  WriteReviewViewController.swift
//  TV shows
//
//  Created by infinum on 29.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

class WriteReviewViewController: UIViewController {

    // MARK: - Properties
    
    var showID: String?
    var show: Show?
    var authInfo: AuthInfo?
    var user: User?
    
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
    
    @IBAction func submitButtonActionHandler(_ sender: UIButton) {
        sendReview()
        self.dismiss(animated: true)
    }
    
    // MARK: - Class methods

    private func setupUI() {
        setupBackButton()
        title = "Write a review"
        setupSubmitButton()
        setupRatingView()
    }
    
    func showAlertOfError(withStatus: String, withMessage: String) {
        let alertController = UIAlertController(
            title: withStatus,
            message: withMessage,
            preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .cancel) { action in }
        alertController.addAction(actionOk)
        self.present(alertController, animated: true) { }
    }
    
}

// MARK: - private post review network call

private extension WriteReviewViewController {
    
    func sendReview() {
        SVProgressHUD.show()
        
        //mozda pukne tu kad dodam prazan komentar
        guard let comment = commentTextField.text else {
            print("nema komentar")
            return }
        guard let showID = showID else {
            print("nema showid")
            return }
        
        guard let authInfo = authInfo else {
            print("nema auth info")
            return }
               
        
        //mozda i tu pukne kod parameters
        let parameters: [String: String] = [
            "rating": String(ratingView.rating),
            "comment": comment,
            "show_id": String(showID)
            ]
        
        let url = Constants.Networking.baseURL + "/reviews"
        
        AF
            .request(
                url,
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: WriteReviewResponse.self) { [weak self] response in
                
                guard let self = self else { return }
                
                switch response.result {
                case.success(let review):
                    SVProgressHUD.dismiss()
                    print("Review sent sucessfully")
                    
                case.failure(let error):
                    self.showAlertOfError(withStatus: "Network error", withMessage: "Oops, can't post your review")
                    SVProgressHUD.dismiss()
                    print(error)
                }
                
            }
            
            
            
        
        
        
        
    }
}

//MARK: - ratingView Delegate

extension WriteReviewViewController: RatingViewDelegate {
  
    func didChangeRating(_ rating: Int) {
        submitButton.isEnabled = true
        submitButton.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
    }
    
}

//MARK: - private UI setup

private extension WriteReviewViewController {
    
    func setupRatingView() {
        ratingView.delegate = self
    }
    
    func setupSubmitButton() {
        submitButton.layer.cornerRadius = 20.0
        submitButton.isEnabled = false
        submitButton.backgroundColor = #colorLiteral(red: 0.8662109971, green: 0.8412159681, blue: 0.9074214101, alpha: 1)
        
    }
    
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