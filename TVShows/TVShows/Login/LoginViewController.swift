//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 05/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

final class LoginViewController: UIViewController, UITextFieldDelegate{
    
    // MARK: - Outlets
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!
    @IBOutlet private weak var rememberMeCheckBox: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineButtonsDesign()
        keyboardManipulation()
    }
    
    private func defineButtonsDesign(){
        
        passwordVisibilityButton.isHidden = true
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func keyboardManipulation(){
        
        passwordTextfield.delegate = self
        usernameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @IBAction private func rememberMeActionHandler() {
        
        if rememberMeCheckBox.currentImage == UIImage(named: "ic-checkbox-empty.png") {
            rememberMeCheckBox.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .normal)
        }
        else {
            rememberMeCheckBox.setImage(UIImage(named: "ic-checkbox-empty.png"), for: .normal)
        }
    }
    
    @IBAction private func passwordShow() {
        
        if passwordVisibilityButton.currentImage == UIImage(named: "eye-visible.png"){
            passwordVisibilityButton.setImage(UIImage(named: "eye-invisible.png"), for: .normal)
            passwordTextfield.isSecureTextEntry = false
        }
        else {
            passwordVisibilityButton.setImage(UIImage(named: "eye-visible.png"), for: .normal)
            passwordTextfield.isSecureTextEntry = true
        }
    }
    
    @IBAction private func paswordFieldEditing() {
        passwordTextfield.isSecureTextEntry = true
        passwordVisibilityButton.isHidden = false
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 150)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction private func loginButtonClick() {
        
        guard
            let username = usernameTextField.text,
            let pass = passwordTextfield.text
            else {
                return
        }
        _alamofireCodableLoginUserWith(email: username, password: pass)
        
    }
    
    
    @IBAction private func registerButtonClick() {
        
        guard
            let username = usernameTextField.text,
            let pass = passwordTextfield.text
            else {
                return
        }
        _alamofireCodableRegisterUserWith(email: username, password: pass)
    }
    
    func showAlertMessage(){
        let alert = UIAlertController(title: "Log in failure", message: "User can not be logged in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func _alamofireCodableLoginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/users/sessions",
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(LoginData.self, keypath: "data")
            }.done { loginData in
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let viewController = sb.instantiateViewController(withIdentifier: "HomeViewController")
                self.navigationController?.navigationItem.hidesBackButton = true
                self.navigationController?.setViewControllers([viewController], animated: true)
                SVProgressHUD.setDefaultMaskType(.black)
              
                print("Success: \(loginData)")
                SVProgressHUD.showSuccess(withStatus: "Success")
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.dismiss()
                self.showAlertMessage()
        }
    }
    
    func _alamofireCodableRegisterUserWith(email: String, password: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/users",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(User.self, keypath: "data")
            }.done { loginData in
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let viewController = sb.instantiateViewController(withIdentifier: "HomeViewController")
                self.navigationController?.navigationItem.hidesBackButton = true
                self.navigationController?.setViewControllers([viewController], animated: true)
               
                SVProgressHUD.setDefaultMaskType(.black)
                let vc = HomeViewController()
                vc.token = loginData.type
                print("Success: \(loginData)")
                SVProgressHUD.showSuccess(withStatus: "Success")
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
}


    


