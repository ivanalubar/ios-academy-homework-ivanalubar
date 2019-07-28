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

final class EpisodeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonNumberLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var episodeID: String = ""
    var showID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getShowDetails()
    }
    
    @IBAction func navigateBackButton() {
        let sb = UIStoryboard(name: Constants.Storyboards.showDetails, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.showDetailsViewConstroller) as? ShowDetailsViewController
            else { return }
        viewController.id = showID
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentsActionHandler() {
        let sb = UIStoryboard(name: Constants.Storyboards.comments, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.commentsViewConstroller) as? CommentsViewController
            else { return }
        viewController.episodeID = episodeID
        viewController.showID = showID
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func getShowDetails() {
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
