//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 27/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import PromiseKit
import SVProgressHUD
import Kingfisher
import KeychainSwift

final class EpisodeDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var seasonNumberLabel: UILabel!
    @IBOutlet private weak var episodeNumberLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    var episodeID: String = ""
    var showID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShowDetails()
        setTheme()
    }
    
    // MARK: - UI Setup
    
    @objc private func setTheme(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(keychain.get("theme") == "dark"){
            view.backgroundColor = .darkGray
            descriptionTextView.textColor = .lightGray
        } else {
            view.backgroundColor = .white
            descriptionTextView.textColor = .darkGray
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func navigateBackButton() {
        
        let sb = UIStoryboard(name: Constants.Storyboards.showDetails, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.showDetailsViewConstroller) as? ShowDetailsViewController
            else { return }
        viewController.id = showID
        dismiss(animated: true, completion: nil)
        print("Navigate back cliked")
    
    }
    
    @IBAction private func navigateToComments() {
        
        print("Navigate to comments clicked")
        let sb = UIStoryboard(name: Constants.Storyboards.comments, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.commentsViewConstroller) as? CommentsViewController
            else { return }
        viewController.episodeID = episodeID
        viewController.showID = showID
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Api calls
    
    private func getShowDetails() {
        SVProgressHUD.show()
        
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/episodes/\(episodeID)",
                    method: .get,
                    encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(EpisodeDetails.self, keypath: "data")
            
            }.done { details in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Ovo je details \(details)")
                print(details.description)
                let url = URL(string: "https://api.infinum.academy/\(details.imageUrl)")
                if (details.imageUrl != "")
                {
                    self.imageView.kf.setImage(with: url)
                }
                else {
                    self.imageView.image = UIImage(named: "icImagePlaceholder")
                }
                if (details.title != "")
                {
                    self.titleLabel.text = details.title
                }
                else {
                    self.titleLabel.text = "Title is empty"
                }
                self.seasonNumberLabel.text = "S" + details.season
                self.episodeNumberLabel.text = "Ep" + details.episodeNumber
                
                if (details.description != "" )
                {
                    self.descriptionTextView.text = details.description
                }
                else {
                    self.descriptionTextView.text = "Description is empty"
                }
                print("Success: \(details)")
                SVProgressHUD.dismiss()
                
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
}
