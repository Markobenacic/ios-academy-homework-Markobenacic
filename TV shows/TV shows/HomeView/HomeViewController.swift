//
//  HomeViewController.swift
//  TV shows
//
//  Created by infinum on 23.07.2021..
//

import UIKit
import Alamofire
import SVProgressHUD

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var showsTableView: UITableView!

    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var userResponse: UserResponse?
    private var shows: [Show] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShows()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Class methods
    
    private func setupUI() {
        self.title = "Shows"
        setupProfileButton()
        setupShowsTableView()
    }
    
}

//MARK: - Network calls for fetching shows

private extension HomeViewController {
    
    func fetchShows() {
        guard let info = authInfo else {
            return
        }
        SVProgressHUD.show()
        
        AF
            .request(
                Constants.Networking.baseURL + "/shows",
                method: .get,
                parameters: ["page": "1", "items": "100"],
                headers: HTTPHeaders(info.headers)
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let showsResponse):
                    SVProgressHUD.dismiss()
                    self.shows = showsResponse.shows
                    self.showsTableView.reloadData()
                    print("fetching shows successful")
                case .failure(let error):
                    print(error)
                    SVProgressHUD.showError(withStatus: "Network error: can't load shows")
                }
            }
    }
}

// MARK: - Private UI setup

private extension HomeViewController {
    
    func setupProfileButton() {
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler)
        )
        profileDetailsItem.tintColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
        navigationItem.rightBarButtonItem = profileDetailsItem
        
    }
    
    @objc
    func profileDetailsActionHandler() {
        
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Profile", bundle: bundle)
        
        let profileViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: ProfileViewController.self)
        ) as! ProfileViewController
        
        let navigationController = UINavigationController(rootViewController: profileViewController)
        
        profileViewController.authInfo = authInfo
        
        present(navigationController, animated: true)
    }
    
    func setupShowsTableView() {
        showsTableView.dataSource = self
        showsTableView.delegate = self
    }
}

// MARK: - Shows TableView datasource

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = showsTableView.dequeueReusableCell(
            withIdentifier: String(describing: TVShowsTableViewCell.self),
            for: indexPath
        ) as! TVShowsTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}

// MARK: - Shows TableView delegates

extension HomeViewController: UITableViewDelegate {
    
    // Pushes ShowsDetailsView with details about pressed show
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: bundle)
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: ShowDetailsViewController.self)
        ) as! ShowDetailsViewController
        
        showDetailsViewController.authInfo = authInfo
        showDetailsViewController.show = shows[indexPath.row]
        showDetailsViewController.user = userResponse?.user
        
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
}
