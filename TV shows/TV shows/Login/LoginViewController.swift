//
//  LoginViewController.swift
//  TV shows
//
//  Created by infinum on 18.07.2021..
//

import Foundation
import UIKit



class LoginViewController : UIViewController{
    
    var numberOfTaps = 0
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func buttonPrint(_ sender: Any) {
        numberOfTaps += 1
        print(numberOfTaps)
        label.text = "taps: " + String(numberOfTaps)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
}
