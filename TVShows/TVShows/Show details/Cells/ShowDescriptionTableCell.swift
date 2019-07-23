//
//  ShowDescriptionTableCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

final class ShowDescriptionTableCell: UITableViewCell {
    
    
   // @IBOutlet weak var showDescription: UILabel!
    //@IBOutlet weak var numberOfEpisodes: UILabel!
    
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
extension ShowDescriptionTableCell {
    func configure(with item: Shows) {
        //showDescription.text = item.title
       
    }
}

// MARK: - Private
private extension ShowDescriptionTableCell {
    func setupUI() {
        // thumbnail.layer.cornerRadius = 20
        //episodeLabel.textColor = UIColor.magenta
    }
}
