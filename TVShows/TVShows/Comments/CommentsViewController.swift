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
    @IBOutlet weak var tableView: UITableView!
    var commentsList = [Comments]()
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagePlaceholderComments: UIImageView!
    @IBOutlet weak var textPlaceholderComments: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePlaceholderComments.isHidden = true
        textPlaceholderComments.isHidden = true
        commentInput.becomeFirstResponder()
        setupTableView()
        getEpisodeComments()
        keyboardManipulation()
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: Constants.Images.navigateBack),
            style: .plain,
            target: self,
            action: #selector(backIconActionHandler)
        )
    }
    @objc private func backIconActionHandler(){
        
        let sb = UIStoryboard(name: Constants.Storyboards.episodeDetails, bundle: nil)
        guard
            let viewController = sb.instantiateViewController(withIdentifier: Constants.Controllers.episodeDetailsViewConstroller) as? EpisodeDetailsViewController
            else { return }
        
        viewController.episodeID = episodeID
        viewController.showID = showID
        print("Navigate back")
        
       // viewController.dismiss(animated: true, completion: nil)
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.setViewControllers([viewController], animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func keyboardManipulation(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func commentPostActionHandler() {
        guard let text = commentInput?.text else {
            return
        }
        postEpisodeComments(text: text, episodeID: episodeID)
        backIconActionHandler()
    }
    
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= ( 20 )
//            }
//        }
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func getEpisodeComments() {
        SVProgressHUD.show()
        
        firstly {
            Alamofire
                .request("https://api.infinum.academy/api/episodes/\(episodeID)/comments",
                    method: .get,
                    encoding: JSONEncoding.default)
                .validate()
                .responseDecodable([Comments].self, keypath: "data")
            }.done { comments in
                SVProgressHUD.setDefaultMaskType(.black)
                print("List of comments \(comments)")
                print(comments)
                self.commentsList = comments
                if (self.commentsList.count < 1) {
                    self.imagePlaceholderComments.isHidden = false
                    self.textPlaceholderComments.isHidden = false
                }
                self.tableView.reloadData()
                print("Success: \(comments)")
                SVProgressHUD.dismiss()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
        }
    }
    
    func postEpisodeComments(text: String, episodeID: String) {
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
            }.done { _ in
                SVProgressHUD.setDefaultMaskType(.black)
                print("Success:")
                SVProgressHUD.dismiss()
                //self.tableView.reloadData()
            }.catch { error in
                print("API failure: \(error)")
                SVProgressHUD.showError(withStatus: "Failure")
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
//        let animation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
//        let animator = Animator(animation: animation)
//        animator.animate(cell: cell, at: indexPath, in: tableView)
        cell.configure(with: commentsList[indexPath.row])
        return cell
        
    }
}

private extension CommentsViewController {
    
    func setupTableView() {
       // tableView.estimatedRowHeight = TableViewRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}