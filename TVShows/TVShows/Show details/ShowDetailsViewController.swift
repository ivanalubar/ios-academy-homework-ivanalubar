//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 21/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit
import Kingfisher

private let TableViewRowHeight: CGFloat = 110

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentShow: ShowDetails? = nil
    var selected: Shows! = nil
    var episodeList = [Episodes]()
    var token: String = ""
    var showID: String = ""
    var showTitle: String = ""
    var id: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading()
    }
    
    func loading(){
        if selected != nil {
            id = selected.id
            titleLabel.text = selected.title
            showTitle = selected.title
        } else { titleLabel.text = showTitle }
        
        setupTableView()
        getShowEpisodes()
        getShowDetails()
    }
    
    // MARK: - Navigation
    
    @IBAction func navigateBackButton() {
        let sb = UIStoryboard(name: Constants.Storyboards.home, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.homeViewConstroller) as? HomeViewController
            else { return }
        viewController.token = token
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func addNewEpisodeButton() {
        let sb = UIStoryboard(name: Constants.Storyboards.addNewEpisode, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.addNewEpisodeViewConstroller) as? AddNewEpisodeViewController
            else { return }
        viewController.token = token
        viewController.showID = id!
        viewController.showTitle = showTitle
        viewController.delegate = self
        print(viewController.showID)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
        
    }
    
    // MARK: - API calls
    
    func getShowDetails() {
        SVProgressHUD.show()
        let headers: HTTPHeaders = ["Authorization": token]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)",
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers:headers)
                .validate()
                .responseDecodable(ShowDetails.self, keypath: "data")
            }.done { details in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Ovo je details \(details)")
                self.descriptionView.text = details.description
                print(details.description)
                let url = URL(string: "https://api.infinum.academy/\(details.imageUrl)")
                self.imageView.kf.setImage(with: url)
                self.tableView.reloadData()
                print("Success: \(details)")
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
    func getShowEpisodes() {
        SVProgressHUD.show()
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)/episodes",
                    method: .get,
                    encoding: JSONEncoding.default)
                .validate()
                .responseDecodable([Episodes].self, keypath: "data")
            }.done { episodes in
                SVProgressHUD.setDefaultMaskType(.black)
                self.episodeList = episodes
                self.episodeList.sort(by: { $0.season < $1.season })
                self.tableView.reloadData()
                print(self.episodeList)
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
}

// MARK: - Extensions

extension ShowDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let items = episodeList[indexPath.row]
        print("Selected Item: \(items)")
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfEpisodesLabel.text = String(episodeList.count)
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailsTableCell.self), for: indexPath) as! ShowDetailsTableCell
            cell.configure(with: episodeList[indexPath.row])
            return cell
    }
}

private extension ShowDetailsViewController {
    
    func setupTableView() {
        tableView.estimatedRowHeight = TableViewRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ShowDetailsViewController: NewEpiodeDelegate{
    func episodeAdded() {
        loading()
    }
}
