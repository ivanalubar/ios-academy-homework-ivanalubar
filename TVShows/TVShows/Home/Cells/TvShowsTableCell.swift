//
//  TvShowsTableCell.swift
//  TVShows
//
//  Created by Infinum on 18/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

final class TvShowsTableCell: UITableViewCell {
    
    // MARK: - Private UI
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.image = nil
        title.text = nil
    }
    
}

// MARK: - Configure
extension TvShowsTableCell {
    func configure(with item: Shows) {
   
        thumbnail.image =  UIImage(named: "icImagePlaceholder")
        title.text = item.title
    }
}

// MARK: - Private
private extension TvShowsTableCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 20
    }
}

