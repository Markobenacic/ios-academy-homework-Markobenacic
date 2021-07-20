//
//  LoginViewController.swift
//  TV shows
//
//  Created by infinum on 18.07.2021..
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
    //MARK: - Outlets
    
    @IBOutlet private weak var numOfTapsLabel: UILabel!
    
    //MARK: - Properties
    
    var numberOfTaps = 0
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction private func tapButtonActionHandler(_ sender: Any) {
        numberOfTaps += 1
        print(numberOfTaps)
        numOfTapsLabel.text = "taps: " + String(numberOfTaps)
    }
    
}
