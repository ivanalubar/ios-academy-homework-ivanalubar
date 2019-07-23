//
//  ShowImageTableCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

final class ShowImageTableCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //showImage.image =  UIImage(named: "icImagePlaceholder")
    }
}

// MARK: - Configure
extension ShowImageTableCell {
    func configure(with item: Shows) {
        //showImage.image =  UIImage(named: "icImagePlaceholder")
    }
}

// MARK: - Private
private extension ShowImageTableCell {
    func setupUI() {
        // thumbnail.layer.cornerRadius = 20
        //episodeLabel.textColor = UIColor.magenta
    }
}
