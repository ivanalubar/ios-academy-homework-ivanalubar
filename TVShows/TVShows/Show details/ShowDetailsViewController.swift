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

private let TableViewRowHeight: CGFloat = 110

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var descriptionView: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    private let refreshControl = UIRefreshControl()


    var currentShow: ShowDetails? = nil
    var selected: Shows! = nil
    var episodeList = [Episodes]()
   // var showID: String = ""
    var showTitle: String = ""
    var id: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShowInfo()
        setupTableView()
    }
    
    func loadShowInfo(){
        if selected != nil {
            id = selected.id
            titleLabel.text = selected.title
            showTitle = selected.title
        } else { titleLabel.text = showTitle }
        
        getShowEpisodes()
        getShowDetails()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh() {
        // Code to refresh table view
        setupTableView()
        getShowEpisodes()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endRefreshing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func endRefreshing(){
        refreshControl.endRefreshing()
    }
    
    // MARK: - Navigation
    
    @IBAction func navigateBackButton() {
        let sb = UIStoryboard(name: Constants.Storyboards.home, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.homeViewConstroller) as? HomeViewController
            else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func postLike() {
        postLikeOnShow()
    }
    
    
    @IBAction func postDislike(_ sender: Any) {
        postDisikeOnShow()
    }
    
    @IBAction func addNewEpisodeButton() {
        let sb = UIStoryboard(name: Constants.Storyboards.addNewEpisode, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.addNewEpisodeViewConstroller) as? AddNewEpisodeViewController
            else { return }
        viewController.showID = id!
        viewController.showTitle = showTitle
        viewController.delegate = self
        print(viewController.showID)
         self.navigationController?.setNavigationBarHidden(true, animated: true)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
        
    }
    
    // MARK: - API calls
    
    func getShowDetails() {
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
    
    func postLikeOnShow() {
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
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.dismiss()
        }
    }
    
    func postDisikeOnShow() {
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
        viewController.episodeID = item.id
        viewController.showID = id
         self.navigationController?.present(viewController, animated: true, completion: nil)
//        self.navigationController?.setViewControllers([viewController], animated: true)
//        self.navigationController?.popViewController(animated: true)
        
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
            let animation = AnimationFactory.makeSlideIn(duration: 0.08, delayFactor: 0.08)
            let animator = Animator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
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

final class Animator {
    
    typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

    private var hasAnimatedAllCells = false
    private let animation: Animation
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        animation(cell, indexPath, tableView)
        
    }
}
enum AnimationFactory {
    
    typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}

