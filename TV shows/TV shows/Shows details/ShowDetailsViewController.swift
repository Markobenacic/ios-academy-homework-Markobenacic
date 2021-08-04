//
//  ShowDetailsViewController.swift
//  TV shows
//
//  Created by infinum on 28.07.2021..
//

import UIKit
import Alamofire
import SVProgressHUD

class ShowDetailsViewController: UIViewController {

    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var show: Show?
    var reviewResponse: ReviewResponse?
    var user: User?
    var showImageUrl: URL?
    
    // MARK: - Outlets
    
    @IBOutlet private var showTableView: UITableView!
    @IBOutlet private var writeReviewButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReviews()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func writeReviewButtonActionHandler(_sender: UIButton) {
        presentWriteReview()
    }
    
    // MARK: - Class methods
    
    private func setupUI() {
        self.title = show?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        setupWriteReviewButton()
        setupReviewsTableView()
    }
    
    private func presentWriteReview() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "WriteReview", bundle: bundle)
        let writeReviewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: WriteReviewViewController.self)
        ) as! WriteReviewViewController
        
        let navigationController = UINavigationController(rootViewController: writeReviewController)
        
        writeReviewController.authInfo = authInfo
        writeReviewController.show = show
        
        writeReviewController.onSubmit = { [weak self] in
            self?.fetchReviews()
        }
        
        present(navigationController, animated: true)
    }
}

// MARK: - Private UI setup

private extension ShowDetailsViewController {
    
    func setupWriteReviewButton() {
        writeReviewButton.layer.cornerRadius = 20.0
    }
}

// MARK: - Network calls for fetching reviews

private extension ShowDetailsViewController {
    
    func fetchReviews() {
        SVProgressHUD.show()
        
        guard let show = show,
              let info = authInfo
        else { return }
        
        let url = Constants.Networking.baseURL + "/shows/" + show.id + "/reviews"
        
        AF
            .request(
                url,
                method: .get,
                parameters: ["page" : "1", "items" : "100"],
                headers: HTTPHeaders(info.headers)
            )
            .validate()
            .responseDecodable(of: ReviewResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case.success(let reviewResponse):
                    SVProgressHUD.dismiss()
                    self.reviewResponse = reviewResponse
                    self.showTableView.reloadData()
                case.failure(let error):
                    print(error)
                    SVProgressHUD.showError(withStatus: "Network error: can't load reviews")
                }
                
            }
    }
}

//MARK: - Private tableView setup

private extension ShowDetailsViewController {
    
    func setupReviewsTableView() {
        showTableView.delegate = self
        showTableView.dataSource = self
    }

}

extension ShowDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let reviewResponse = reviewResponse else { return 0 }
        
        return reviewResponse.reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = showTableView.dequeueReusableCell(
                withIdentifier: String(describing: MainShowDataCell.self),
                for: indexPath
            ) as! MainShowDataCell
            
            guard let reviewResponse = reviewResponse,
                  let show = show
            else { return cell }
            
            cell.configure(show: show, reviews: reviewResponse.reviews, showImageUrl: showImageUrl)
            
            return cell
        } else {
            let cell = showTableView.dequeueReusableCell(
                withIdentifier: String(describing: CommentCell.self),
                for: indexPath
            ) as! CommentCell
            
            guard let reviewResponse = reviewResponse else { return cell }
            
            // We are offseting our index by -1 because the first cell doesnt use individual reviews
            // Is there a better way than writing a static number (-1) ? 
            cell.configure(with: reviewResponse.reviews[indexPath.row - 1])
            
            return cell
        }
    }
}
