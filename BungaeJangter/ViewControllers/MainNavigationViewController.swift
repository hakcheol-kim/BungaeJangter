//
//  MainNavigationViewController.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let forgroundColor = UIColor.black
        let backgroundColor = UIColor.white
        let tintColor: UIColor = .blue
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor : forgroundColor, .font : UIFont.systemFont(ofSize: 17, weight: .medium)]
        appearance.largeTitleTextAttributes = [.foregroundColor : forgroundColor, .font : UIFont.systemFont(ofSize: 24, weight: .bold)]
        appearance.backgroundColor = backgroundColor
        
        let appearanceS = UINavigationBarAppearance()
        appearanceS.configureWithOpaqueBackground()
        appearanceS.titleTextAttributes = [.foregroundColor : forgroundColor, .font : UIFont.systemFont(ofSize: 17, weight: .medium)]
        appearanceS.largeTitleTextAttributes = [.foregroundColor : forgroundColor, .font : UIFont.systemFont(ofSize: 24, weight: .bold)]
        appearanceS.backgroundColor = backgroundColor
        appearanceS.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceS
        UINavigationBar.appearance().isTranslucent = true
        UIScrollView.appearance().bounces = true

        //UIScrollView.appearance().delaysContentTouches = true
        
        UINavigationBar.appearance().tintColor = tintColor
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
}
extension MainNavigationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
