//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 05/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var rememberMeCheckBox: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        defineButtonDesign()
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    private func defineButtonDesign(){
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func defineBottomBorders(){
        
        let bottomUsernameBorder = CALayer()
        bottomUsernameBorder.backgroundColor = UIColor.lightGray.cgColor
        bottomUsernameBorder.frame = CGRect(x: 0.0, y: usernameTextField.frame.height + 5, width: usernameTextField.frame.width, height: 1.0);
        usernameTextField.layer.addSublayer(bottomUsernameBorder)
        
        let bottomPasswordBorder = CALayer()
        bottomPasswordBorder.backgroundColor = UIColor.lightGray.cgColor
        bottomPasswordBorder.frame = CGRect(x: 0.0, y: passwordTextfield.frame.height + 5, width: passwordTextfield.frame.width, height: 1.0);
        passwordTextfield.layer.addSublayer(bottomPasswordBorder)
    }
    
    // MARK: - Actions
    
    @IBAction private func RememberMe(_ sender: Any) {
        if rememberMeCheckBox.currentImage == UIImage(named: "ic-checkbox-empty.png") {
            rememberMeCheckBox.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .normal)
        }
        else {
            rememberMeCheckBox.setImage(UIImage(named: "ic-checkbox-empty.png"), for: .normal)
        }
    }
    
}
