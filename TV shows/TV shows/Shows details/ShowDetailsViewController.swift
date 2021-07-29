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
    var showID: String?
    var show: Show?
    var reviewResponse: ReviewResponse?
    
    
    // MARK: - Outlets
    @IBOutlet var showTableView: UITableView!
    @IBOutlet var writeReviewButton: UIButton!
    
    // MARK: - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReviews()
        setupUI()
    }
    
    private func setupUI() {
        self.title = show?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        setupWriteReviewButton()
        setupReviewsTableView()
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
        
        guard let showID = showID,
              let info = authInfo
        else { return }
        
        let url = Constants.Networking.baseURL + "/shows/" + showID + "/reviews"
        print(showID)
        
        
        AF
            .request(
                url,
                method: .get,
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
            
            cell.configure(show: show, reviews: reviewResponse.reviews)
            
            return cell
        } else {
            let cell = showTableView.dequeueReusableCell(
                withIdentifier: String(describing: CommentCell.self),
                for: indexPath
            ) as! CommentCell
            
            guard let reviewResponse = reviewResponse else { return cell }
            
            cell.configure(with: reviewResponse.reviews[indexPath.row - 1])
            
            return cell
        }
    }
    
    
}