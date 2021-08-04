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
    @IBOutlet private weak var loginButton: AnimatedButton!
    @IBOutlet private weak var registerButton: AnimatedButton!
    
    // for animations
    @IBOutlet private weak var showsImageView: UIImageView!
    @IBOutlet private weak var line1View: UIView!
    @IBOutlet private weak var line2View: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var rememberMeLabel: UILabel!
    
    
    // MARK: - Properties
    
    private var passwordVisibilityButton: UIButton?
    private var isCheckBoxChecked: Bool = false
    private var userResponse: UserResponse?
    private var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateIntro()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonActionHandler(_ sender: AnimatedButton) {
                
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
    
    @IBAction func registerButtonActionHandler(_ sender: AnimatedButton) {
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
        
        
  //      navigationController?.pushViewController(homeViewController, animated: true)
        
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}

// MARK: - Animations


private extension LoginViewController {
    
    
    // Would this kind of animation make the user experience worse, since they're waiting extra 4 seconds for animations to finish? I would imagine it would. And also app users are impatient.
    // Either way I understand those decisions are UX designers' to make, but its fun to think about :D
    func animateIntro() {
        
        showsImageView.transform = CGAffineTransform(translationX: -12, y: 289)
        emailTextField.alpha = 0
        passwordTextField.alpha = 0
        titleLabel.alpha = 0
        subTitleLabel.alpha = 0
        line1View.alpha = 0
        line2View.alpha = 0
        checkBoxButton.alpha = 0
        rememberMeLabel.alpha = 0
        loginButton.alpha = 0
        registerButton.alpha = 0
        
        UIView.animate(
            withDuration: 3.0,
            delay: 0.5,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: [.curveEaseInOut],
            animations: {
                self.showsImageView.transform = .identity
        })
        
        UIView.animate(
            withDuration: 1.5,
            delay: 2.5,
            animations: {
                self.emailTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.titleLabel.alpha = 1
                self.subTitleLabel.alpha = 1
                self.line1View.alpha = 1
                self.line2View.alpha = 1
                self.checkBoxButton.alpha = 1
                self.rememberMeLabel.alpha = 1
                self.loginButton.alpha = 1
                self.registerButton.alpha = 1
        })
    }
    
    func animateLoginError() {
        
        // This way of animating this seems a bit cleaner than the one commented below, since the latter uses a lot of nested completed: closures. Didn't delete it because I'm interested which way is better.
        let animationEmail = CABasicAnimation(keyPath: "position")
        animationEmail.duration = 0.08
        animationEmail.repeatCount = 2
        animationEmail.autoreverses = true
        animationEmail.fromValue = NSValue(
            cgPoint: CGPoint(
                x: emailTextField.center.x - 5,
                y: emailTextField.center.y))
        animationEmail.toValue = NSValue(
            cgPoint: CGPoint(
                x: emailTextField.center.x + 5,
                y: emailTextField.center.y))
        
        let animationPassword = CABasicAnimation(keyPath: "position")
        animationPassword.duration = 0.08
        animationPassword.repeatCount = 2
        animationPassword.autoreverses = true
        animationPassword.fromValue = NSValue(
            cgPoint: CGPoint(
                x: passwordTextField.textInputView.center.x - 5,
                y: passwordTextField.textInputView.center.y))
        animationPassword.toValue = NSValue(
            cgPoint: CGPoint(
                x: passwordTextField.textInputView.center.x + 5,
                y: passwordTextField.textInputView.center.y))
        
        emailTextField.layer.add(animationEmail, forKey: "position")
        // Used textInputView here because I don't want to shake the eye thingy.
        passwordTextField.textInputView.layer.add(animationPassword, forKey: "position")
        
        
//        UIView.animate(
//            withDuration: 0.05,
//            animations: {
//                self.emailTextField.transform = CGAffineTransform(translationX: 5.0, y: 0.0)
//                self.passwordTextField.textInputView.transform = CGAffineTransform(translationX: 5.0, y: 0.0)
//            },
//            completion: {_ in
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.emailTextField.transform = CGAffineTransform(translationX: -5.0, y: 0.0)
//                    self.passwordTextField.textInputView.transform = CGAffineTransform(translationX: -5.0, y: 0.0)
//                },
//                completion: {_ in
//                    UIView.animate(withDuration: 0.1, animations: {
//                        self.emailTextField.transform = CGAffineTransform(translationX: 5.0, y: 0.0)
//                        self.passwordTextField.textInputView.transform = CGAffineTransform(translationX: 5.0, y: 0.0)
//                    },
//                    completion: {_ in
//                        UIView.animate(withDuration: 0.05, animations: {
//                            self.emailTextField.transform = .identity
//                            self.passwordTextField.textInputView.transform = .identity
//                        }
//                        )
//                    }
//                    )
//                }
//                )
//            }
//        )
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
                    SVProgressHUD.dismiss()
                    self.animateLoginError()
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
        
        if checkBoxButton.isSelected {
            let encoder = PropertyListEncoder()
            if let encoded = try? encoder.encode(authInfo) {
                UserDefaults.standard.set(encoded, forKey: Constants.Keys.authInfo)
            }
        }
        
        pushHomeView()
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
