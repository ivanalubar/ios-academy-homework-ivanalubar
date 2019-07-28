//
//  UIImagePickerViewController.swift
//  TVShows
//
//  Created by Infinum on 27/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

protocol SelfDelegate: class {
    func getImageUpload(value: String)
}

final class UIImagePickerViewController: UIViewController {
    
    var delegate: SelfDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.delegate?.getImageUpload(value: "/1533822149166-image.png")
        
    }
}
