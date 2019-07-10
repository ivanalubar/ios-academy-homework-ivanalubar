//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 05/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


class LoginViewController: UIViewController {
    @IBOutlet weak var CheckBox: UIButton!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var CreateAccountBtn: UIButton!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var UserName: UITextField!
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
//        stackView.axis = size.width > size.height ? .horizontal : .vertical

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CheckBox.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .selected)
        
        
        // Do any additional setup after loading the view.
        LoginBtn.backgroundColor = UIColor(rgb: 0xff758c)
        LoginBtn.tintColor = UIColor(rgb: 0xffffff)
        
        CreateAccountBtn.backgroundColor = UIColor(rgb: 0xffffff)
        CreateAccountBtn.tintColor = UIColor(rgb: 0xff758c)
        
//        Bottom border for UserName TextField
        let UserNameBorder = CALayer()
        UserNameBorder.backgroundColor = UIColor.lightGray.cgColor
        UserNameBorder.frame = CGRect(x: 0.0, y: UserName.frame.height + 5, width: UserName.frame.width, height: 1.0);
        UserName.layer.addSublayer(UserNameBorder)
        
//        Bottom border for Password TextField
        let PasswordBorder = CALayer()
        PasswordBorder.backgroundColor = UIColor.lightGray.cgColor
        PasswordBorder.frame = CGRect(x: 0.0, y: Password.frame.height + 5, width: Password.frame.width, height: 1.0);
        Password.layer.addSublayer(PasswordBorder)
        
//        Login button - rounded edges
        LoginBtn.layer.cornerRadius = 5
        LoginBtn.layer.borderWidth = 1
        LoginBtn.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction func LoginButton(_ sender: Any) {
    
    }
    
    
    @IBAction func CheckBox(_ sender: Any) {
        if CheckBox.currentImage == UIImage(named: "ic-checkbox-empty.png") {
            CheckBox.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .normal)
        }
        else {
            CheckBox.setImage(UIImage(named: "ic-checkbox-empty.png"), for: .normal)
        }
        
    }
    
}
