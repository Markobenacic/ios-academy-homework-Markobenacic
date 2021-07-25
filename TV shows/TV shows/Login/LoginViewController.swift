//
//  LoginViewController.swift
//  TV shows
//
//  Created by infinum on 18.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire

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
    private var userResponse: UserResponse?
    
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Actions
    
    @IBAction func loginButtonActionHandler(_ sender: Any) {
        // login also can't be pressed unless there is some text in email and password, so I'm force unwrapping. (Not sure if it's the right thing to do..)
        loginUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func registerButtonActionHandler(_ sender: Any) {
        
        // register can't be pressed unless there is some text in email and password, so I'm force unwrapping. (Not sure if it's the right thing to do..)
        registerUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    //MARK: - class methods
    
    private func setupUI() {
        setupVisibilityButton()
        setupEmailAndPasswordTextField()
        setupCheckBoxButton()
        setupLoginAndRegisterButtons()
    }
    
    private func pushHomeView() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        let homeViewController = storyboard.instantiateViewController(
            withIdentifier: "HomeViewController"
        )
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}

//MARK: - Login and register network calls

private extension LoginViewController {
    
    func loginUser(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let url = Constants.Networking.baseURL + "/users/sign_in"
        
        AF
            .request(
                url,
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                switch response.result {
                case .success(let userResponse):
                    SVProgressHUD.dismiss()
                    self?.userResponse = userResponse
                    print("Sign in successful")
                    
                    //jel ovo safe ovako pisati?
                    self?.pushHomeView()
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Sign in error")
                    print(error)
                }
            }
    }
    
    func registerUser(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        let url = Constants.Networking.baseURL + "/users"
        AF
            .request(
                url,
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                switch response.result {
                case .success(let userResponse):
                    SVProgressHUD.dismiss()
                    self?.userResponse = userResponse
                    print("Registration successful")
                   
                    self?.parseHeaders(headersDict: response.response?.headers.dictionary)
                    
                    //jel ovo safe ovako pisati?
                    self?.pushHomeView()
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Register error")
                    print(error)
                }
            }
    }
    func parseHeaders(headersDict: [String : String]?){
        //
    }
}

//MARK: - private UI setup
private extension LoginViewController {
    
    private func setupLoginAndRegisterButtons() {
        loginButton.layer.cornerRadius = 15.0
        
        loginButton.isEnabled = false
        registerButton.isEnabled = false
        
        loginButton.backgroundColor = #colorLiteral(red: 0.4808383741, green: 0.4189229082, blue: 0.6904364692, alpha: 1)
        
        loginButton.setTitleColor(#colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1), for: .normal)
        loginButton.setTitleColor(.lightGray, for: .disabled)
        
        registerButton.setTitleColor(.lightGray, for: .disabled)
        registerButton.setTitleColor(.white, for: .normal)
                
    }
    
    private func setupEmailAndPasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string:"Email",
            attributes: [NSAttributedString.Key.foregroundColor :UIColor.lightGray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        emailTextField.textColor = .white
        passwordTextField.textColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupCheckBoxButton() {
        
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
        
        checkBoxButton.addTarget(
            self,
            action: #selector(checkBoxButtonActionHandler(_:)),
            for: .touchUpInside)
    }
    
    private func setupVisibilityButton() {
        
        let passwordVisibilityButton = UIButton(type: .custom)
        
        passwordVisibilityButton.setImage(UIImage(named: "Visibility-icon-closed"), for: .normal)
        
        passwordVisibilityButton.setImage(UIImage(named: "Visibility-icon"), for: .selected)
        
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

private extension LoginViewController {
    
    @objc
    func checkBoxButtonActionHandler(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc
    func passwordVisibilityButtonActionHandler(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
}

//MARK: - Delegates

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (emailTextField.hasText && passwordTextField.hasText) {
            loginButton.backgroundColor = .white
            loginButton.isEnabled = true
            registerButton.isEnabled = true
        } else {
            loginButton.backgroundColor = #colorLiteral(red: 0.4808383741, green: 0.4189229082, blue: 0.6904364692, alpha: 1)
            loginButton.isEnabled = false
            registerButton.isEnabled = false
        }
    }
}
