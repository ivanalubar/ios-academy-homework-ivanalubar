//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 27/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import SVProgressHUD
import KeychainSwift

final class CommentsViewController: UIViewController {
    
    var episodeID: String = ""
    var showID: String = ""
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var commentInput: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imagePlaceholderComments: UIImageView!
    @IBOutlet private weak var textPlaceholderComments: UITextView!
    @IBOutlet private weak var keyboardPlaceholder: UIView!
    @IBOutlet private weak var inputBottomConstraint: NSLayoutConstraint!
    
    private var commentsList = [Comments]()
    private let refreshControl = UIRefreshControl()
    private var keyboardHeight: CGFloat = 270
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCommentsView()
        setTheme()
    }
    
    @objc private func setTheme(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(keychain.get("theme") == "dark"){
            view.backgroundColor = .darkGray
            UITextField.appearance().keyboardAppearance = .dark
        } else {
            view.backgroundColor = .white
            UITextField.appearance().keyboardAppearance = .light
        }
    }
    
    private func loadCommentsView(){
       // commentInput.becomeFirstResponder()
        setupTableView()
        getEpisodeComments()
        setupNavigationBar()
        imagePlaceholderComments.isHidden = true
        textPlaceholderComments.isHidden = true
        textPlaceholderComments.frame.size.height = keyboardHeight
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(startRefrshing), for: UIControl.Event.valueChanged)
    }
    
    @objc func startRefrshing(){
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
    }
    
    private func setupNavigationBar(){
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: Constants.Images.navigateBack),
            style: .plain,
            target: self,
            action: #selector(backIconActionHandler)
        )
    }
    
    @objc func refresh() {
        setupTableView()
        getEpisodeComments()
        tableView.reloadData()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endRefreshing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func endRefreshing(){
        refreshControl.endRefreshing()
    }
    
    @objc private func backIconActionHandler(){
        
        let sb = UIStoryboard(name: Constants.Storyboards.episodeDetails, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.episodeDetailsViewConstroller) as? EpisodeDetailsViewController
            else { return }
        
        viewController.episodeID = episodeID
        viewController.showID = showID
        print("Navigate back")
        dismiss(animated: true, completion: nil)
    }
    
    
    private func keyboardManipulation(){

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func commentPostActionHandler() {
        guard let text = commentInput?.text else {
            return
        }
        postEpisodeComments(text: text, episodeID: episodeID)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= ( keyboardSize.height - 150 )
            }
        }
        inputBottomConstraint.constant = 500
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = .zero
        }
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let item = commentsList[indexPath.row]
            print(item.id)
            deleteEpisodeComment(id: item.id, row: indexPath)
            print(indexPath.row)
        }
    }
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.ok, style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func getEpisodeComments() {
        SVProgressHUD.show()
        
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/episodes/\(episodeID)/comments",
                    method: .get,
                    encoding: JSONEncoding.default)
                .validate()
                .responseDecodable([Comments].self, keypath: "data")
            }.done { [weak self] comments in
                SVProgressHUD.setDefaultMaskType(.black)
                print("List of comments \(comments)")
                print(comments)
                self?.commentsList = comments
                if ((self?.commentsList.count)! < 1) {
                    self?.imagePlaceholderComments.isHidden = false
                    self?.textPlaceholderComments.isHidden = false
                }
                self?.tableView.reloadData()
                print("Success: \(comments)")
                self?.endRefreshing()
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
    private func postEpisodeComments(text: String, episodeID: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "text": text,
            "episodeId": episodeID
        ]
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let headers: HTTPHeaders = ["Authorization": keychain.get("token")!]

        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/comments",
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                     headers: headers)
                .validate()
                .responseData()
            }.done { [weak self] _ in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Success:")
                SVProgressHUD.dismiss()
                self?.commentInput.text = ""
                self?.imagePlaceholderComments.isHidden = true
                self?.textPlaceholderComments.isHidden = true
                self?.refresh()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
    private func deleteEpisodeComment(id: String, row: IndexPath) {
        SVProgressHUD.show()
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        let headers: HTTPHeaders = ["Authorization": keychain.get("token")!]
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/comments/\(id)",
                         method: .delete,
                         encoding: JSONEncoding.default,
                         headers: headers)
                .validate()
                .responseData()
            }.done { [weak self] response in
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.dismiss()
                print("Success: comment deleted!")
                self?.commentInput.text = ""
                self?.tableView.beginUpdates()
                self?.commentsList.remove(at: row.row)
                self?.tableView.deleteRows(at: [row], with: UITableView.RowAnimation.fade)
                self?.tableView.endUpdates()
                self?.refresh()
            }.catch { [weak self] error in
                print("API failure: \(error)")
                self?.showAlert(title: Constants.AlertMessages.failMessageTitle, message: Constants.AlertMessages.deleteFail)
                SVProgressHUD.dismiss()
        }
    }
}

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = commentsList[indexPath.row]
        print("Selected Item: \(item)")
    }
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentsTableCell.self), for: indexPath) as! CommentsTableCell
        cell.configure(with: commentsList[indexPath.row])
        return cell
        
    }
}

private extension CommentsViewController {
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
