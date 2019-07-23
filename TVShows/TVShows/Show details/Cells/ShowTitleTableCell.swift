//
//  ShowTitleImageCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

final class ShowTitleTableCell: UITableViewCell {
    
    
    //@IBOutlet weak var showTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //episodeLabel.text = nil
    }
}

// MARK: - Configure
extension ShowTitleTableCell {
    func configure(with item: Shows) {
        //showTitle.text = item.title
    }
}

// MARK: - Private
private extension ShowTitleTableCell {
    func setupUI() {
        // thumbnail.layer.cornerRadius = 20
       // episodeLabel.textColor = UIColor.magenta
    }
}
