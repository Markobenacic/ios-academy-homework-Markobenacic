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
    private var isCheckBoxChecked: Bool = false
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Actions
    
    //MARK: - class methods
    
    private func setupUI(){
        setupVisibilityButton()
        setupEmailAndPasswordTextField()
        setupCheckBoxButton()
        setupLoginAndRegisterButtons()
    }
    
}

//MARK: - private UI setup
private extension LoginViewController{
    
    private func setupLoginAndRegisterButtons(){
        loginButton.layer.cornerRadius = 15.0
        
        loginButton.isEnabled = false
        registerButton.isEnabled = false
        
        loginButton.backgroundColor = #colorLiteral(red: 0.4808383741, green: 0.4189229082, blue: 0.6904364692, alpha: 1)
        
        loginButton.setTitleColor(#colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1), for: UIControl.State.normal)
        loginButton.setTitleColor(.lightGray, for: UIControl.State.disabled)
        
        registerButton.setTitleColor(.lightGray, for: UIControl.State.disabled)
        registerButton.setTitleColor(.white, for: UIControl.State.normal)
        
    }
    
    private func setupEmailAndPasswordTextField(){
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        emailTextField.textColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    private func setupCheckBoxButton(){
        
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: UIControl.State.normal)
        
        checkBoxButton.addTarget(self,
                                 action: #selector(checkBoxButtonActionHandler(_:)),
                                 for: UIControl.Event.touchUpInside)
    }
    
    private func setupVisibilityButton(){
        
        let passwordVisibilityButton = UIButton(type: .custom)
        
        passwordVisibilityButton.setImage(UIImage(named: "Visibility-icon-closed"), for: .normal)
        passwordVisibilityButton.tintColor = .white
        
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
    private func checkBoxButtonActionHandler(_ sender: Any){
        let checkBoxButton = sender as! UIButton
        
        if isCheckBoxChecked{
            isCheckBoxChecked = false
            checkBoxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: UIControl.State.normal)
        }else{
            isCheckBoxChecked = true
            checkBoxButton.setImage(UIImage(named: "ic-checkbox-selected"), for: UIControl.State.normal)
        }
    }
    
    @objc
    func passwordVisibilityButtonActionHandler(_ sender: Any){
        let visibilityButton = sender as! UIButton
        visibilityButton.isSelected = !visibilityButton.isSelected
        
        if(visibilityButton.isSelected){
            passwordTextField.isSecureTextEntry = false
            visibilityButton.setImage(UIImage(named: "Visibility-icon"), for: .normal)
            
        }else{
            passwordTextField.isSecureTextEntry = true
            visibilityButton.setImage(UIImage(named: "Visibility-icon-closed"), for: .normal)
            
        }
    }
}

//MARK: - Delegates

extension LoginViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(emailTextField.hasText && passwordTextField.hasText){
            loginButton.backgroundColor = .white
            loginButton.isEnabled = true
            registerButton.isEnabled = true
        }else{
            loginButton.backgroundColor = #colorLiteral(red: 0.4808383741, green: 0.4189229082, blue: 0.6904364692, alpha: 1)
            loginButton.isEnabled = false
            registerButton.isEnabled = false
        }
    }
}
