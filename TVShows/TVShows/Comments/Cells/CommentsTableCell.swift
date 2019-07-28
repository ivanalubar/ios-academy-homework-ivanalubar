//
//  ShowDetailsTableCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

final class CommentsTableCell: UITableViewCell {
    

    @IBOutlet weak var imageComment: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextfield: UITextView!
    
    var userImages: [UIImage] = []
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentTextfield.text = nil
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
        // thumbnail.layer.cornerRadius = 20
       // episodeLabel.textColor = UIColor.black
        userImages.append(UIImage(imageLiteralResourceName: "img-placeholder-user1"))
        userImages.append(UIImage(imageLiteralResourceName: "img-placeholder-user2"))
        userImages.append(UIImage(imageLiteralResourceName: "img-placeholder-user3"))
    }
}
