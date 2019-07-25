//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum on 24/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

final class AddNewEpisodeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var episodeTitleLabel: UITextField!
    @IBOutlet weak var seasonNumberLabel: UITextField!
    @IBOutlet weak var episodeNumberLabel: UITextField!
    @IBOutlet weak var episodeDescriptionLabel: UITextField!
    
    var token: String = ""
    var showID: String = ""
    var showTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.ButtonNames.cancel,
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.ButtonNames.add,
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(rgb: 0xff758c)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0xff758c)
    }
    
    @objc func didSelectAddShow(){
        print("Clicked Add Show")
        guard
            let title = episodeTitleLabel.text,
            let season = seasonNumberLabel.text,
            let episode = episodeNumberLabel.text,
            let description = episodeDescriptionLabel.text
            else { return }
        self.addNewEpisode(title: title, season: season, episode: episode, description: description)
    }
    
    @objc func didSelectCancel(){
        print("Clicked Cancel")
        let sb = UIStoryboard(name: Constants.Storyboards.showDetails, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.showDetailsViewConstroller) as? ShowDetailsViewController
            else { return }
        
        viewController.id = showID
        viewController.token = token
        viewController.showTitle = showTitle
        print(viewController.id!)
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Alert messagess
    
    func showFailureMessage(){
        let alert = UIAlertController(title: Constants.AlertMessages.failMessageTitle, message: Constants.AlertMessages.addEpisodeFailure, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessMessage(){
        let alert = UIAlertController(title: Constants.AlertMessages.sucessMessageTitle, message: Constants.AlertMessages.addEpisodeSuccess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - API calls
    
    func addNewEpisode(title: String, season: String, episode: String, description: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": showID,
            "title": title,
            "description": description,
            "episodeNumber": episode,
            "season": season
        ]
        let headers: HTTPHeaders = ["Authorization": token]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/episodes",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseData()
            }.done { _ in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Success:")
                self.showSuccessMessage()
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                self.showFailureMessage()
                SVProgressHUD.dismiss()
        }
    }
}

// MARK: - Color conversion

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
