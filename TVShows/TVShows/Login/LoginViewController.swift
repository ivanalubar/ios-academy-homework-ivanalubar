//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 05/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var counter: Int = 0
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Count: UIButton!
    @IBOutlet weak var Reset: UIButton!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var Loading: UIButton!
    @IBOutlet weak var StopAnimating: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    
//    Counter reset
    @IBAction func Reset(_ sender: UIButton) {
        counter = 0
        Label.text = String(self.counter)
    }
    
//    Counter increase
    @IBAction func Count(_ sender: UIButton) {
        counter += 1
        Label.text = String(self.counter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Activity.startAnimating()
        Activity.isHidden = false
        
//        Hide while loading
        Label.isHidden = true
        Reset.isHidden = true
        Count.isHidden = true
        Loading.isHidden = true
        StopAnimating.isHidden = true
        StopAnimating.backgroundColor = UIColor.darkGray
        StopAnimating.layer.cornerRadius = 5
        StopAnimating.layer.borderWidth = 1
        
//        Show after 3 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.Label.isHidden = false
            self.Reset.isHidden = false
            self.Count.isHidden = false
            self.Loading.isHidden = false
            self.Activity.stopAnimating()
            self.Activity.isHidden = true
            self.StopAnimating.isHidden = true
        }
        
//        Setting background color and font
        view.backgroundColor = UIColor.magenta
        Label.font = UIFont(name: "Arial", size: 25)
        Label.textColor = UIColor.black
        TitleLabel.font = UIFont(name: "Arial", size: 15)
        Label.text = String(counter)
        Count.backgroundColor = .clear
        Count.frame.size = CGSize(width: 60.0, height: 20.0)
        Count.layer.borderColor = UIColor.lightGray.cgColor
        Activity.isHidden = true
    }
    
//    Show loading animation and hide everything else
    @IBAction func Loading(_ sender: Any) {
            Count.isHidden = true
            Reset.isHidden = true
            Label.isHidden = true
            Activity.startAnimating()
            Activity.isHidden = false
            StopAnimating.isHidden = false
            Loading.isHidden = true
    }
    
//    Hide loading animation and show everything else
    @IBAction func StopAnimating(_ sender: Any) {
        Activity.isHidden = true
        Activity.stopAnimating()
        Label.isHidden = false
        Reset.isHidden = false
        Count.isHidden = false
        Loading.isHidden = false
        Activity.stopAnimating()
        Activity.isHidden = true
        StopAnimating.isHidden = true
    }
}
