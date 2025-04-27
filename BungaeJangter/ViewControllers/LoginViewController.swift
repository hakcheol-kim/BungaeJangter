//
//  LoginViewController.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit

class LoginViewController: UIViewController  {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func buttonActionControllers(_ sender: UIButton) {
        if sender == loginButton {
            
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
}
