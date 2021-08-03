//
//  AppDelegate.swift
//  TV shows
//
//  Created by infinum on 08.07.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        selectView()
        return true
    }
    
    private func selectView() {
        let navigationController = UINavigationController()
        
        let decoder = PropertyListDecoder()
        
        if let data = UserDefaults.standard.data(forKey: Constants.Keys.authInfo),
           let authInfo: AuthInfo = try? decoder.decode(AuthInfo.self, from: data)
        {
            let bundle = Bundle.main
            let storyboard = UIStoryboard(name: "Home", bundle: bundle)
            let homeViewController = storyboard.instantiateViewController(
                withIdentifier: "HomeViewController"
            ) as! HomeViewController
            
            homeViewController.authInfo = authInfo
            
            navigationController.setViewControllers([homeViewController], animated: true)
        } else {
            let bundle = Bundle.main
            let storyboard = UIStoryboard(name: "Login", bundle: bundle)
            let loginViewController = storyboard.instantiateViewController(
                withIdentifier: "LoginViewController"
            ) as! LoginViewController
            
            navigationController.setViewControllers([loginViewController], animated: true)
        }
        
        window?.rootViewController = navigationController
    }
}

