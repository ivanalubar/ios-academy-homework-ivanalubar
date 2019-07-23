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

    @IBOutlet weak var episodeTitleLabel: UITextField!
    @IBOutlet weak var seasonNumberLabel: UITextField!
    @IBOutlet weak var episodeNumberLabel: UITextField!
    @IBOutlet weak var episodeDescriptionLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addNewEpisode(title: String, season: String, episode: String, description: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            
            //"showId": showId,
            //"mediaId": mediaId,
            "title": title,
            "description": description,
            "episodeNumber": episode,
            "season": season
            
        ]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/episodes",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(NewEpisode.self, keypath: "data")
            }.done { loginData in
                SVProgressHUD.setDefaultMaskType(.black)
               
                print("Success: \(loginData)")
                SVProgressHUD.showSuccess(withStatus: "Success")
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
}
