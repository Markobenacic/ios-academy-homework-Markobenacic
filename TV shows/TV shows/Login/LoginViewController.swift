//
//  LoginViewController.swift
//  TV shows
//
//  Created by infinum on 18.07.2021..
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var checkBoxButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    //MARK: - Properties
    
    private var passwordVisibilityButton: UIButton?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Actions
    
    
    
    //MARK: - class methods
    
    private func setupUI(){
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 15.0
        setupVisibilityButton()
    }
}

//MARK: - private UI setup
private extension LoginViewController{
    
    private func setupVisibilityButton(){
        
        let passwordVisibilityButton = UIButton(type: .system)
        
        passwordVisibilityButton.setImage(UIImage(named: "eye.slash.fill"), for: .normal)
        
        passwordVisibilityButton.addTarget(
            self,
            action: #selector(passwordVisibilityButtonActionHandler(_:)),
            for: .touchUpInside)
        
        passwordTextField.rightView = passwordVisibilityButton
        passwordTextField.rightViewMode = .always
        
        self.passwordVisibilityButton = passwordVisibilityButton
    }
}

//MARK: - Private action handlers

private extension LoginViewController{
     
    @objc
    func passwordVisibilityButtonActionHandler(_ sender: Any){
        let visibilityButton = sender as! UIButton
        visibilityButton.isSelected = !visibilityButton.isSelected
        
        if(visibilityButton.isSelected){
            self.passwordTextField.isSecureTextEntry = false
            visibilityButton.setImage(UIImage(named: "eye.fill"), for: .normal)
        }else{
            self.passwordTextField.isSecureTextEntry = true
            visibilityButton.setImage(UIImage(named: "eye.slash.fill"), for: .normal)
        }
    }
}
