//
//  TvShowsCollectionCell.swift
//  TVShows
//
//  Created by Infinum on 31/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class TvShowsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.image = nil
    }
}

// MARK: - Configure
extension TvShowsCollectionCell {
    func configure(with item: Shows) {
        let url = URL(string: "https://api.infinum.academy/\(item.imageUrl)")
        self.thumbnail.kf.setImage(with: url)
    }
}

// MARK: - Private
private extension TvShowsCollectionCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 10
    }
}
