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

private let cornerRadius: CGFloat = 5
private let borderWidth: CGFloat = 1

final class LoginViewController: UIViewController, UITextFieldDelegate{
    
    // MARK: - Outlets
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!
    @IBOutlet private weak var rememberMeCheckBox: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        keyboardManipulation()
    }
    
    private func configureUI(){
        
        passwordVisibilityButton.isHidden = true
        loginButton.layer.cornerRadius = cornerRadius
        loginButton.layer.borderWidth = borderWidth
        loginButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func keyboardManipulation(){
        
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @IBAction private func rememberMeActionHandler() {
        
        let image = rememberMeCheckBox.isSelected ? UIImage(named: Constants.Images.unchecked) : UIImage(named: Constants.Images.checked)
        rememberMeCheckBox.setImage(image, for: .normal)
        rememberMeCheckBox.isSelected.toggle()
    }
    
    @IBAction private func passwordShow() {
        
        if passwordTextField.isSecureTextEntry {
            passwordVisibilityButton.setImage(UIImage(named: Constants.Images.passwordHide), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordVisibilityButton.setImage(UIImage(named: Constants.Images.passwordShow), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction private func paswordFieldEditing() {
        passwordTextField.isSecureTextEntry = true
        passwordVisibilityButton.isHidden = false
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = .zero
        }
    }
    
    @IBAction private func loginButtonClick() {

        guard
            let username = usernameTextField.text,
            let pass = passwordTextField.text
            else { return }
        loginUserWith(email: username, password: pass)
        
    }
    
    @IBAction private func registerButtonClick() {
        
        guard
            let username = usernameTextField.text,
            let pass = passwordTextField.text
            else { return }
        registerUserWith(email: username, password: pass)
    }
    
    // MARK: - Alert messagess
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
   
    // MARK: - Navigation
    
    private func navigateToHome(token: String){
        let sb = UIStoryboard(name: Constants.Storyboards.home, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.homeViewConstroller) as? HomeViewController
            else { return }
        viewController.token = token
        print(viewController.token)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - API calls
    
    func loginUserWith(email: String, password: String) {
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
            }.done { [weak self] loginData in
                self?.navigateToHome(token: loginData.token)
                SVProgressHUD.setDefaultMaskType(.black)
                print("Success: \(loginData)")
                SVProgressHUD.dismiss()
            }.catch { [weak self] error in
                print("API failure: \(error)")
                SVProgressHUD.dismiss()
                self?.showAlert(title: Constants.AlertMessages.failMessageTitle, message: Constants.AlertMessages.loginFailure)
        }
    }
    
    func registerUserWith(email: String, password: String) {
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
            }.done { [weak self] loginData in
                SVProgressHUD.setDefaultMaskType(.black)
                let vc = HomeViewController()
                vc.token = loginData.type
                print("Success: \(loginData)")
                self?.showAlert(title: Constants.AlertMessages.sucessMessageTitle, message: Constants.AlertMessages.registrationSuccess)
                SVProgressHUD.dismiss()
            }.catch {[weak self] error in
                print("API failure: \(error)")
                SVProgressHUD.dismiss()
                self?.showAlert(title: Constants.AlertMessages.failMessageTitle, message: Constants.AlertMessages.registrationFaliure)
        }
    }
}


    


