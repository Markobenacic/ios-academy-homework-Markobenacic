//
//  ShowDetailsViewController.swift
//  TV shows
//
//  Created by infinum on 28.07.2021..
//

import UIKit

class ShowDetailsViewController: UIViewController {

    // MARK: - Properties
    var authInfo: AuthInfo?
    var showID: String?
    var show: Show?
    
    // MARK: - Outlets
    @IBOutlet var showTitle: UILabel!
    @IBOutlet var showTableView: UITableView!
    @IBOutlet var writeReviewButton: UIButton!
    
    // MARK: - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
