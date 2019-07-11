//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 05/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    private var numberOfClicks: Int = 0
    @IBOutlet private weak var numberOfClicksLabel: UILabel!
    @IBOutlet private weak var touchCounterButton: UIButton!
    @IBOutlet private weak var resetCounterButton: UIButton!
    @IBOutlet private weak var Activity: UIActivityIndicatorView!
    @IBOutlet private weak var loadingButton: UIButton!
    @IBOutlet private weak var stopAnimating: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        stackView.axis = size.width > size.height ? .horizontal : .vertical

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimtation()
        settingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.configureUI()
        }
    }
    
    private func settingView(){
        view.backgroundColor = UIColor.magenta
        numberOfClicksLabel.font = UIFont(name: "Arial", size: 25)
        numberOfClicksLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Arial", size: 15)
        numberOfClicksLabel.text = String(numberOfClicks)
        touchCounterButton.backgroundColor = .clear
        touchCounterButton.frame.size = CGSize(width: 60.0, height: 20.0)
        touchCounterButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func configureUI() {
        numberOfClicksLabel.isHidden = false
        resetCounterButton.isHidden = false
        touchCounterButton.isHidden = false
        loadingButton.isHidden = false
        Activity.stopAnimating()
        Activity.isHidden = true
        stopAnimating.isHidden = true
    }
    
    private func startAnimtation() {
        Activity.startAnimating()
        Activity.isHidden = false
        numberOfClicksLabel.isHidden = true
        resetCounterButton.isHidden = true
        touchCounterButton.isHidden = true
        loadingButton.isHidden = true
        stopAnimating.isHidden = true
        stopAnimating.backgroundColor = UIColor.darkGray
        stopAnimating.layer.cornerRadius = 5
        stopAnimating.layer.borderWidth = 1
    }
    
    // MARK: - Actions
    
    @IBAction private func resetCounterActionHandler() {
        numberOfClicks = 0
        numberOfClicksLabel.text = String(self.numberOfClicks)
    }
    
    @IBAction private func touchCounterButtonActionHandler() {
        numberOfClicks += 1
        numberOfClicksLabel.text = String(self.numberOfClicks)
    }

    @IBAction private func loadingButtonActionHandler() {
        touchCounterButton.isHidden = true
        resetCounterButton.isHidden = true
        numberOfClicksLabel.isHidden = true
        Activity.startAnimating()
        Activity.isHidden = false
        stopAnimating.isHidden = false
        loadingButton.isHidden = true
    }
    
    @IBAction private func stopAnimatingActionHandler() {
        Activity.isHidden = true
        Activity.stopAnimating()
        numberOfClicksLabel.isHidden = false
        resetCounterButton.isHidden = false
        touchCounterButton.isHidden = false
        loadingButton.isHidden = false
        Activity.stopAnimating()
        Activity.isHidden = true
        stopAnimating.isHidden = true
    }
}
