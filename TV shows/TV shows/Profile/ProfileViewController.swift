//
//  ProfileViewController.swift
//  TV shows
//
//  Created by infinum on 04.08.2021..
//

import UIKit
import SVProgressHUD
import Kingfisher
import Alamofire

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var changePhotoButton: UIButton!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    private var user: User?
    private let imagePicker = UIImagePickerController()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        fetchUser()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func changePhotoButtonActionHandler(_sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    // MARK: - Class methods
    
    private func setupUI() {
        setupBackButton()
        setupLogoutButton()
        setupProfileImage()
        navigationItem.title = "My Account"
    }
}

// MARK: - UIImagePickerController delegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFit
            
            uploadImage(image: pickedImage)
            
        }
        fetchImage()
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

// MARK: - Private UI setup

private extension ProfileViewController {
    
    func setupProfileImage() {
        profileImage.kf.setImage(
            with: user?.imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder")
        )
    }
    
    func setupLogoutButton() {
        logoutButton.layer.cornerRadius = 25.0
    }
    
    func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
        )
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
    }
    
    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Network calls
private extension ProfileViewController {
    
    func fetchImage() {
        profileImage.kf.setImage(with: user?.imageUrl)
        
    }
    
    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.9),
              let authInfo = self.authInfo
                
        else { return }
        let requestData = MultipartFormData()
        requestData.append(
            imageData,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
        
        AF
            .upload(
                multipartFormData: requestData,
                to: Constants.Networking.baseURL + "/users",
                method: .put,
                headers: HTTPHeaders(authInfo.headers)
                )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let userResponse):
                    self.user = userResponse.user
                    print(self.user?.email as Any)
                case .failure(let error):
                    print("zugzug")
                    print(error.errorDescription as Any)
                }
                
            }
    }
    
    // Should probably save the user in a singleton, so this method doesn't have to fetch user every time this viewcontroller is presented
    func fetchUser() {
        guard let authInfo = authInfo else {
            return
        }
        
        SVProgressHUD.show()
        
        AF
            .request(
                Constants.Networking.baseURL + "/users/me",
                method: .get,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self ] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let userResponse):
                    SVProgressHUD.dismiss()
                    self.user = userResponse.user
                    self.emailLabel.text = self.user?.email
                case .failure(let error):
                    print(error)
                    SVProgressHUD.showError(withStatus: "Network error: can't load user")
                }
            }
    }
}
