//
//  CollectionViewHomeController.swift
//  TVShows
//
//  Created by Infinum on 31/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//
import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit
import KeychainSwift

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var items = [Shows]()
    private var grid: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadShowInfo()
        getApiShows()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem?.tintColor = .gray
        navigationItem.rightBarButtonItem?.tintColor = .gray
    }
    
    // MARK: - UI Setup
    
    private func loadShowInfo() {
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        var image: UIImage!
        
        if (keychain.get("grid") == "true"){
            image = UIImage(named: Constants.Images.listview)
        } else {
            image = UIImage(named: Constants.Images.gridview)
        }
        UINavigationBar.appearance().tintColor = UIColor.gray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: Constants.Images.logout),
            style: .plain,
            target: self,
            action: #selector(logoutActionHandler)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(collectionViewSwitcher)
        )
    }
    
    @objc private func setTheme(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(keychain.get("theme") == "dark"){
            keychain.set("dark", forKey: "theme")
            keychain.synchronizable = true
            view.backgroundColor = .darkGray
            collectionView.backgroundColor = .darkGray
        } else {
            keychain.set("light", forKey: "theme")
            keychain.synchronizable = true
            view.backgroundColor = .white
            collectionView.backgroundColor = .white
        }
    }
    
    // MARK: - Alert message
    
    private func showApiFailedMessage(){
        let alert = UIAlertController(title: Constants.AlertMessages.failMessageTitle, message: Constants.AlertMessages.getShowsFaliure, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Api calls
    
    func reloadData(){
        
        self.collectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            self.collectionView.reloadSections(indexSet)
        }, completion: nil)
    }
    
    private func getApiShows() {
        SVProgressHUD.show()
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let headers = [ "Authorization": keychain.get("token")! ]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows",
                         method: .get,
                         parameters: nil,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseDecodable([Shows].self, keypath: "data")
            
            }.done { [weak self] shows in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Success: \(shows)")
                self?.items = shows
                self?.reloadData()
                SVProgressHUD.dismiss()
                
            }.catch { [weak self]  error in
                print("API failure: \(error)")
                self?.showApiFailedMessage()
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func logoutActionHandler(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        keychain.set("false", forKey: "loggedIn")
        keychain.synchronizable = true
        print("Navigate to login")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func collectionViewSwitcher(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(navigationItem.rightBarButtonItem?.image == UIImage( named: Constants.Images.listview)){
            navigationItem.rightBarButtonItem?.image = UIImage( named: Constants.Images.gridview)
            keychain.set("false", forKey: "grid")
            grid = false
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage( named: Constants.Images.listview)
            grid = true
            keychain.set("true", forKey: "grid")
        }
       reloadData()
    }
}

// MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
        navigateToDetails(item: item)
    }
    
    fileprivate func scaleCells(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let cells = collectionView.visibleCells
        let distances = cells.map { $0.frame.minY }
            .map { abs(currentOffset - $0) }
        let scales = distances.map { (d) -> CGFloat in
            let constraind = min(200, max(50, d))
            let burek = (constraind - 50) / (200 - 50)
            return (1 - burek) * (1 - 0.85) + 0.85
            
        }
        zip(cells, scales).forEach { (cell, scale) in
            cell.transform = .init(scaleX: scale, y: scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentOffset = collectionView.contentOffset.y
        let d = abs(currentOffset - cell.frame.minY)
        let constraind = min(200, max(50, d))
        let burek = (constraind - 50) / (200 - 50)
        let scale = (1 - burek) * (1 - 0.85) + 0.85
        cell.transform = .init(scaleX: scale, y: scale)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scaleCells(scrollView)
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let t = keychain.get("grid")
        if (t == "true") {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TvShowsGridCollectionCell.self), for: indexPath) as! TvShowsGridCollectionCell
            cell.configure(with: items[indexPath.row])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TvShowsListCollectionCell.self), for: indexPath) as! TvShowsListCollectionCell
            cell.configure(with: items[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let t = keychain.get("grid")
        if (t == "true") {
            return CGSize(width: 160, height: 248)
        } else {
            return CGSize(width: 414, height: 248)
        }
    }
}

private extension HomeViewController {
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}



