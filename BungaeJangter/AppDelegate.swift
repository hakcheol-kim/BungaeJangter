//
//  AppDelegate.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared = AppDelegate()
    weak var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
extension AppDelegate {
    var rootViewController: UIViewController? {
        return AppDelegate.shared.window?.rootViewController
    }
    
    static func showToast(_ message: String) {
        guard let rootvc = AppDelegate.shared.rootViewController else { return }
        
        if let view = rootvc.view.viewWithTag(1010) {
            view.removeFromSuperview()
        }
        let view = UIView()
        view.tag = 1010
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.text = message
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
        rootvc.view.addSubview(view)
        view.leadingAnchor.constraint(equalTo: rootvc.view.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: rootvc.view.trailingAnchor, constant: -16).isActive = true
        view.bottomAnchor.constraint(equalTo: rootvc.view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            hideToast()
        }
    }
    static func hideToast() {
        guard let rootvc = AppDelegate.shared.rootViewController else { return }
        
        if let view = rootvc.view.viewWithTag(1010) {
            view.removeFromSuperview()
        }
    }
    
    static func showLoading(_ isLoading: Bool) {
        guard let rootvc = AppDelegate.shared.rootViewController else { return }
        
        if let view = rootvc.view.viewWithTag(2020) {
            view.removeFromSuperview()
        }
        if isLoading == false { return }
        
        let view = UIView()
        view.tag = 2020
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let progress = UIActivityIndicatorView(style: .large)
        progress.color = .accent
        progress.tintColor = .accent
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progress)
        progress.widthAnchor.constraint(equalToConstant: 80).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 80).isActive = true
        progress.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        rootvc.view.addSubview(view)
        view.topAnchor.constraint(equalTo: rootvc.view.topAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: rootvc.view.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: rootvc.view.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: rootvc.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        progress.startAnimating()
    }
    
}
