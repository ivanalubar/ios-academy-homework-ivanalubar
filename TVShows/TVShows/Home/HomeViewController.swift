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

private let TableViewRowHeight: CGFloat = 110

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    public var token: String = ""
    private var items = [Shows]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApiShows()
//        let logoutItem = UIBarButtonItem.init(image: UIImage(name: "ic-logout"),
//                                                                style: .plain,
//                                                                target: self,
//                                                                action: #selector(_logotActionHandler))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
           // title: "Logout",
            image: UIImage(named: "ic-logout"),
            style: .plain,
            target: self,
            action: #selector(logotActionHandler)
        )
    }
    
    @objc private func logotActionHandler(){

        print("Navigate to login")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
//        let vc = LoginViewController()
//        present(vc, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Alert messages
    
    func showApiFailedMessage(){
        let alert = UIAlertController(title: Constants.AlertMessages.failMessageTitle, message: Constants.AlertMessages.getShowsFaliure, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - API calls
    
    func getApiShows() {
        SVProgressHUD.show()
        let headers = [ "Authorization": token ]
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
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                self.showApiFailedMessage()
                SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Navigation
    
    private func navigateToDetails(item: Shows){
        let sb = UIStoryboard(name: Constants.Storyboards.showDetails, bundle: nil)
        
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.showDetailsViewConstroller) as? ShowDetailsViewController
            else { return }
        
        viewController.selected = item
        viewController.token = token
        print(viewController.token)
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Extensions

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
        navigateToDetails(item: item)
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
        
        tableView.estimatedRowHeight = TableViewRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
