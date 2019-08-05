//
//  ShowDetailsTableCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import KeychainSwift

final class CommentsTableCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageComment: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var commentTextfield: UITextView!
    
    private var userImages: [UIImage] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentTextfield.text = nil
        setTheme()
    }
    
    @objc private func setTheme(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(keychain.get("theme") == "dark"){
            commentTextfield.backgroundColor = .darkGray
        } else {
           commentTextfield.backgroundColor = .white
        }
    }
}

// MARK: - Configure

extension CommentsTableCell {
    func configure(with item: Comments) {
        let string = item.userEmail
        let array = string.components(separatedBy: "@")
        print(array)
        usernameLabel.text = array[0]
        commentTextfield.text = item.text
        
        imageView?.image = userImages[0]
        userImages.shuffle()
        
    }
}

// MARK: - Private

private extension CommentsTableCell {
    func setupUI() {
        userImages.append(UIImage(imageLiteralResourceName: Constants.Images.userPlaceholder1))
        userImages.append(UIImage(imageLiteralResourceName: Constants.Images.userPlaceholder2))
        userImages.append(UIImage(imageLiteralResourceName: Constants.Images.userPlaceholder3))
    }
}
