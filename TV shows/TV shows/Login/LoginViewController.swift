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
    
    // MARK: - Properties
    
    private var passwordVisibilityButton: UIButton?
    private var isCheckBoxChecked: Bool = false
    private var userResponse: UserResponse?
    private var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonActionHandler(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            print("email or password field is empty")
            return
        }
        loginUser(email: email, password: password)
    }
    
    @IBAction func registerButtonActionHandler(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            print("email or password field is empty")
            return
        }
        registerUser(email: email, password: password)
    }
    
    // MARK: - class methods
    
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
        ) as! HomeViewController
        homeViewController.authInfo = authInfo
        homeViewController.userResponse = userResponse
        
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}

// MARK: - Login and register network calls

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
                guard let self = self else { return }
                
                switch response.result {
                case .success(let userResponse):
                    SVProgressHUD.dismiss()
                    let headers = response.response?.headers.dictionary ?? [:]
                    self.userResponse = userResponse
                    self.handleSuccessfulLoginOrRegister(for: userResponse.user, headers: headers)
                    print("Sign in successful")
                case .failure(let error):
                    
                    // Should I put "invalid email or password" message here? Should I include cases for both serverside errors and invalid credentials? If invalid credentials are presented by 401 response, how is "can't access the server" presented?
                    self.showAlertOfError(withStatus: "Login error", withMessage: "Oops, something went wrong")
                    SVProgressHUD.dismiss()
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
                guard let self = self else { return }
                
                switch response.result {
                case .success(let userResponse):
                    SVProgressHUD.dismiss()
                    let headers = response.response?.headers.dictionary ?? [:]
                    self.userResponse = userResponse
                    self.handleSuccessfulLoginOrRegister(for: userResponse.user, headers: headers)
                    print("Registration successful")
                case .failure(let error):
                    self.showAlertOfError(withStatus: "Registration error", withMessage: "Oops, something went wrong")
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
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
    
    func handleSuccessfulLoginOrRegister(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        self.authInfo = authInfo
        self.pushHomeView()
    }
}

// MARK: - private UI setup
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

// MARK: - Private action handlers

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

// MARK: - Delegates

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
