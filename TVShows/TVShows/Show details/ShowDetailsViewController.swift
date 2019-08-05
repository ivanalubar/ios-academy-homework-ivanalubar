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
import KeychainSwift
import JTMaterialTransition

private let TableViewRowHeight: CGFloat = 110

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dislikeButton: UIButton!
    @IBOutlet private weak var viewUnderTableView: UIView!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var descriptionView: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    
    private let refreshControl = UIRefreshControl()

    var transition: JTMaterialTransition?
    var currentShow: ShowDetails? = nil
    var selected: Shows! = nil
    var episodeList = [Episodes]()
    var showTitle: String = ""
    var id: String! = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.transition = JTMaterialTransition(animatedView: self.addButton)
        loadShowInfo()
        setupTableView()
        setTheme()
    }
    
    // MARK: - UI Setup
    
    @objc private func setTheme(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(keychain.get("theme") == "dark"){
            view.backgroundColor = .darkGray
            tableView.backgroundColor = .darkGray
            descriptionView.backgroundColor = .darkGray
            descriptionView.textColor = .lightGray
            titleLabel.textColor = .white
            titleLabel.backgroundColor = .darkGray
            viewUnderTableView.backgroundColor = .darkGray
        } else {
            view.backgroundColor = .white
            tableView.backgroundColor = .white
            descriptionView.backgroundColor = .white
            descriptionView.textColor = .darkGray
            titleLabel.textColor = .black
            titleLabel.backgroundColor = .white
            viewUnderTableView.backgroundColor = .white
        }
    }
    
    private func loadShowInfo(){
        
        if selected != nil {
            id = selected.id
            titleLabel.text = selected.title
            showTitle = selected.title
        } else { titleLabel.text = showTitle }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        getShowEpisodes()
        getShowDetails()
    }
    
    // MARK: - Navigation
    
    @IBAction private func navigateBackButton() {
        
        let sb = UIStoryboard(name: Constants.Storyboards.collectionHome, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.homeViewController) as? HomeViewController
            else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.setViewControllers([viewController], animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction private func postLike() {
        postLikeOnShow()
    }
    
    @IBAction private func postDislike() {
        postDisikeOnShow()
    }
    
    @IBAction private func addNewEpisodeButton() {
        
        let sb = UIStoryboard(name: Constants.Storyboards.addNewEpisode, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.addNewEpisodeViewConstroller) as? AddNewEpisodeViewController
            else { return }
        viewController.episodeDetails = Current(showID: selected.id , episodeID: "")
        viewController.showTitle = showTitle
        viewController.delegate = self
        print(viewController.episodeDetails.showID)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self.transition
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    @objc func refresh() {
        
        setupTableView()
        getShowEpisodes()
        getShowDetails()
    }
    
    @objc func endRefreshing(){
        refreshControl.endRefreshing()
    }
    
    // MARK: - API calls
    
    private func getShowDetails() {
        SVProgressHUD.show()
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let headers: HTTPHeaders = ["Authorization": keychain.get("token")!]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)",
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers:headers)
                .validate()
                .responseDecodable(ShowDetails.self, keypath: "data")
            
            }.done { [weak self] details in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Ovo je details \(details)")
                self?.descriptionView.text = details.description
                self?.likesLabel.text = String(details.likesCount)
                print(details.description)
                SVProgressHUD.dismiss()
                self?.endRefreshing()
                let url = URL(string: "https://api.infinum.academy/\(details.imageUrl)")
                if (details.imageUrl != "")
                {
                    self?.imageView.kf.setImage(with: url)
                }
                else {
                    self?.imageView.image = UIImage(named: "icImagePlaceholder")
                }
                self?.tableView.reloadData()
                print("Success: \(details)")
                
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
    private func getShowEpisodes() {
        SVProgressHUD.show()
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)/episodes",
                    method: .get,
                    encoding: JSONEncoding.default)
                .validate()
                .responseDecodable([Episodes].self, keypath: "data")
            }.done { [weak self] episodes in
                SVProgressHUD.setDefaultMaskType(.black)
                self?.episodeList = episodes
                self?.episodeList.sort(by: { $0.season < $1.season })
                self?.tableView.reloadData()

                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
    private func postLikeOnShow() {
        SVProgressHUD.show()
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let headers: HTTPHeaders = ["Authorization": keychain.get("token")!]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)/like",
                         method: .post,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseData()
            }.done { [weak self] _ in
                SVProgressHUD.setDefaultMaskType(.black)
                self?.getShowDetails()
                print("Success:")
                self?.likeButton.isEnabled = false
                self?.dislikeButton.tintColor = .gray
                self?.dislikeButton.isEnabled = true
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.dismiss()
        }
    }
    
    private func postDisikeOnShow() {
        SVProgressHUD.show()
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let headers: HTTPHeaders = ["Authorization": keychain.get("token")!]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/shows/\(id!)/dislike",
                    method: .post,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseData()
            }.done { [weak self] _ in
                SVProgressHUD.setDefaultMaskType(.black)
                self?.getShowDetails()
                print("Success:")
                self?.dislikeButton.isEnabled = false
                self?.likeButton.tintColor = .gray
                self?.likeButton.isEnabled = true
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.dismiss()
        }
    }
}

// MARK: - Extensions

extension ShowDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = episodeList[indexPath.row]
        print("Selected Item: \(item)")
        let sb = UIStoryboard(name: Constants.Storyboards.episodeDetails, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.episodeDetailsViewConstroller) as? EpisodeDetailsViewController
            else { return }
        viewController.episodeDetails = Current(showID: selected.id, episodeID: item.id)
        self.navigationController?.present(viewController, animated: true, completion: nil)
        
    }
}

extension ShowDetailsViewController: UIScrollViewDelegate {
    // check direction
}

extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfEpisodesLabel.text = String(episodeList.count)
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailsTableCell.self), for: indexPath) as! ShowDetailsTableCell
            let keychain = KeychainSwift()
            keychain.synchronizable = true
            if(keychain.get("theme") == "dark"){
                cell.backgroundColor = .darkGray
            } else {
                cell.backgroundColor = .white
            }
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
        loadShowInfo()
    }
}

