//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 13/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

//struct TVShowItem {
//    let name: String
//    let image: UIImage?
//}

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    public var token: String = ""
    
//    @IBOutlet weak var tableView: UITableView!
   
    private var items = [Shows]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _getApiShow()
        
    }
    
    func _getApiShow() {
        SVProgressHUD.show()
        let headers = [
            "Authorization": token]

        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows",
                         method: .get,
                         parameters: nil,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseDecodable([Shows].self, keypath: "data")
            }.done { shows in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Success: \(shows)")
                shows.forEach { show in
                    self.items.append(show)
                }
                self.setupTableView()
                SVProgressHUD.showSuccess(withStatus: "Success")
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TvShowsTableCell.self), for: indexPath) as! TvShowsTableCell
        
        cell.configure(with: items[indexPath.row])
 
        return cell
    }
    
    
}


private extension HomeViewController {
    
    func setupTableView() {
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
