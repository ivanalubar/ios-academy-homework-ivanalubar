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
    
    @IBAction func Reset(_ sender: UIButton) {
        self.counter = 0
        self.Label.text = String(self.counter)
    }
    
    @IBAction func Count(_ sender: UIButton) {
        self.counter += 1
        self.Label.text = String(self.counter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        Label.text = String(counter)
    }
    
    
   
}
