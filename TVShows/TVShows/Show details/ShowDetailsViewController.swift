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

final class ShowDetailsViewController: UIViewController {
    
    @IBOutlet weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private let TableViewRowHeight: CGFloat = 110
    public var currentShow: ShowDetails? = nil
    public var selected: Shows? = nil
    private var episodeList = [Episodes]()
    public var token: String = ""
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selected)
        label.text = selected?.title
        setupTableView()
        getShowDetails()
        getShowEpisodes()
    }
    
    @IBAction func navigateBackButton() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: "HomeViewController")
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    @IBAction func addNewEpisodeButton() {
        let sBoard = UIStoryboard(name: "AddNewEpisode", bundle: nil)
        let vc = sBoard.instantiateViewController(withIdentifier: "AddNewEpisodeController")
        //let vc = AddNewEpisodeViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
        
    }
    
    func getShowDetails() {
        SVProgressHUD.show()
        let id: String? = selected?.id
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)",
                    method: .get,
                    encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(ShowDetails.self, keypath: "data")
            }.done { details in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Ovo je details \(details)")
                self.descriptionLabel.text = details.description
                print(details.description)
                self.tableView.reloadData()
                print("Success: \(details)")
                SVProgressHUD.showSuccess(withStatus: "Success")
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
    func getShowEpisodes() {
        SVProgressHUD.show()
        let id: String? = selected?.id
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)/episodes",
                    method: .get,
                    encoding: JSONEncoding.default)
                .validate()
                .responseDecodable([Episodes].self, keypath: "data")
            }.done { episodes in
                SVProgressHUD.setDefaultMaskType(.black)
                episodes.forEach { episode in
                    self.episodeList.append(episode)
                }
                self.episodeList.sort(by: { $0.season < $1.season })
                self.tableView.reloadData()
                print(self.episodeList)
                //print("Success: \(episodes)")
                SVProgressHUD.showSuccess(withStatus: "Success")
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
}

extension ShowDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let items = episodeList[indexPath.row]
        print("Selected Item: \(items)")
        //navigateToDetails(item: episodeList)
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfEpisodesLabel.text = String(episodeList.count)
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowImageTableCell.self), for: indexPath) as! ShowImageTableCell
//            cell.configure(with: selected!)
//            return cell
//        } else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowTitleTableCell.self), for: indexPath) as! ShowTitleTableCell
//            cell.configure(with: selected!)
//            return cell
//        } else if indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDescriptionTableCell.self), for: indexPath) as! ShowDescriptionTableCell
//            getShowDetails()
//            cell.configure(with: selected!)
//            return cell
//        }
//        else {
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailsTableCell.self), for: indexPath) as! ShowDetailsTableCell
            cell.configure(with: episodeList[indexPath.row])
            return cell
       // }
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
