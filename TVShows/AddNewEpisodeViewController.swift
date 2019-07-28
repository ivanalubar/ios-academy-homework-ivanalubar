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
import SkyFloatingLabelTextField
import KeychainSwift

protocol NewEpiodeDelegate: class {
    func episodeAdded()
}

final class AddNewEpisodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var episodeTitleLabel: UITextField!
    @IBOutlet weak var seasonNumberLabel: UITextField!
    @IBOutlet weak var episodeNumberLabel: UITextField!
    @IBOutlet weak var episodeDescriptionLabel: UITextField!
    var episodeTitle: SkyFloatingLabelTextField!
    var seasonNumber: SkyFloatingLabelTextField!
    var episodeNumber: SkyFloatingLabelTextField!
    var episodeDescription: SkyFloatingLabelTextField!
    var image: UIImage!
    
    weak var delegate: NewEpiodeDelegate?
    var showID: String = ""
    var showTitle: String = ""
    var mediaId: String = ""
    
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
        
        episodeTitleSubview()
        episodeSeasonSubview()
        episodeNumberSubview()
        episodeDescriptionSubview()
    }
    
    func episodeTitleSubview(){
        episodeTitle = SkyFloatingLabelTextField(frame: episodeTitleLabel.frame)
        episodeTitle.placeholder = "Episode title"
        episodeTitle.title = "Episode title"
        episodeTitle.titleColor = UIColor.lightGray
        episodeTitle.selectedTitleColor = UIColor.lightGray
        self.episodeTitleLabel.addSubview(episodeTitle)
        self.episodeTitleLabel.text = episodeTitle.text
    }
    
    func episodeSeasonSubview(){
        seasonNumber = SkyFloatingLabelTextField(frame: seasonNumberLabel.frame)
        seasonNumber.placeholder = "Season number"
        seasonNumber.title = "Season number"
        seasonNumber.titleColor = UIColor.lightGray
        seasonNumber.selectedTitleColor = UIColor.lightGray
        self.seasonNumberLabel.addSubview(seasonNumber)
        self.seasonNumberLabel.text = seasonNumber.text
    }
    
    func episodeNumberSubview(){
        episodeNumber = SkyFloatingLabelTextField(frame: episodeNumberLabel.frame)
        episodeNumber.placeholder = "Episode number"
        episodeNumber.title = "Episode number"
        episodeNumber.titleColor = UIColor.lightGray
        episodeNumber.selectedTitleColor = UIColor.lightGray
        self.episodeNumberLabel.addSubview(episodeNumber)
        self.episodeNumberLabel.text = episodeNumber.text
    }
    
    func episodeDescriptionSubview(){
        episodeDescription = SkyFloatingLabelTextField(frame: episodeDescriptionLabel.frame)
        episodeDescription.placeholder = "Episode description"
        episodeDescription.title = "Episode description"
        episodeDescription.titleColor = UIColor.lightGray
        episodeDescription.selectedTitleColor = UIColor.lightGray
        self.episodeDescriptionLabel.addSubview(episodeDescription)
        self.episodeDescriptionLabel.text = episodeDescription.text
    }
    
    @objc func didSelectAddShow(){
        print("Clicked Add Show")
        guard
            let title = episodeTitle.text,
            let season = seasonNumber.text,
            let episode = episodeNumber.text,
            let description = episodeDescription.text
            else { return }
        self.addNewEpisode(title: title, season: season, episode: episode, description: description)
    }
    
    @IBAction func imagePickerButton() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not avaliable")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction) in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage
        let image = info [UIImagePickerController.InfoKey.originalImage]
        print(image!)
        uploadImageOnAPI()
        print("*****************************************")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhotoActionHandler() {

        
    }
    
    @objc func didSelectCancel(){
        print("Clicked Cancel")
        let sb = UIStoryboard(name: Constants.Storyboards.showDetails, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.showDetailsViewConstroller) as? ShowDetailsViewController
            else { return }
        
        viewController.id = showID
        viewController.showTitle = showTitle
        print(viewController.id!)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Alert messagess
    
    func showFailureMessage(){
        let alert = UIAlertController(title: Constants.AlertMessages.failMessageTitle, message: Constants.AlertMessages.addEpisodeFailure, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - API calls
    
    func addNewEpisode(title: String, season: String, episode: String, description: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": showID,
            "title": title,
            "mediaId": mediaId,
            "description": description,
            "episodeNumber": episode,
            "season": season
        ]
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        let headers: HTTPHeaders = ["Authorization": keychain.get("token")!]
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
                SVProgressHUD.dismiss()
                self.delegate?.episodeAdded()
                self.dismiss(animated: true)
            }.catch { error in
                print("API failure: \(error)")
                self.showFailureMessage()
                SVProgressHUD.dismiss()
        }
    }
    
    func uploadImageOnAPI() {
        SVProgressHUD.show()
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        let someUIImage = image
        let imageByteData = image.pngData()!
        let headers: HTTPHeaders = ["Authorization": keychain.get("token")!]
        
            Alamofire
                .upload(multipartFormData: { multipartFormData in multipartFormData.append(
                    imageByteData,
                    withName: "file",
                    fileName: "image.png",
                    mimeType: "image/png")
                }, to: "https://api.infinum.academy/api/media",
                         method: .post,
                        headers: headers)
                { [weak self] result in
                    switch result {
                        case .success (let uploadRequest, _, _ ):
                            self?.processUploadRequest(uploadRequest)
                        case .failure (let error):
                            print("Fail: \(error)")
                    }
            }
    }
    func processUploadRequest(_ uploadRequest: UploadRequest){
        uploadRequest
            .responseDecodableObject(keyPath: "data"){
                (response: DataResponse<Media>) in
                switch response.result {
                case .success (let media):
                    print(media)
                    print("This is what I get ****************")
                case .failure (let error):
                    print(error)
                }
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



