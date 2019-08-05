//
//  TvShowsCollectionCell.swift
//  TVShows
//
//  Created by Infinum on 31/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class TvShowsGridCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var thumbnail: UIImageView!
    
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

extension TvShowsGridCollectionCell {
    func configure(with item: Shows) {
        let url = URL(string: "https://api.infinum.academy/\(item.imageUrl)")
        self.thumbnail.kf.setImage(with: url)
    }
}

// MARK: - Private

private extension TvShowsGridCollectionCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 15
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 15
    }
}
