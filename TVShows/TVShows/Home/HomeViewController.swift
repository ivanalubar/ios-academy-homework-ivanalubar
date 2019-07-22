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
    
    private func tableRowSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
        let vc = ShowDetailsViewController()
        vc.selected = currentCell
        showAlertMessage()
        _showDetails()
        print(currentCell)
        
    }
    
    func showAlertMessage(){
        let alert = UIAlertController(title: "Log in failure", message: "User can not be logged in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func showDetails(){
        let sb = UIStoryboard(name: "ShowDetails", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: "ShowDetailsViewController")
        self.navigationController?.navigationItem.hidesBackButton = true
         self.navigationController?.setViewControllers([viewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func _showDetails() {
        SVProgressHUD.show()
        
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/{showId}",
                         method: .get,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(Shows.self, keypath: "data")
            }.done { loginData in
                
                self.showDetails()
                SVProgressHUD.setDefaultMaskType(.black)
               
                print("Success: \(loginData)")
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
