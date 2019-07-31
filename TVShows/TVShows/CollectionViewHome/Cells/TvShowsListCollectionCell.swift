//
//  TvShowsListCollectionCell.swift
//  TVShows
//
//  Created by Infinum on 31/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class TvShowsListCollectionCell: UICollectionViewCell {
    
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
extension TvShowsListCollectionCell {
    func configure(with item: Shows) {
        let url = URL(string: "https://api.infinum.academy/\(item.imageUrl)")
        thumbnail.kf.setImage(with: url)
        title.text = item.title
    }
}

// MARK: - Private
private extension TvShowsListCollectionCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 10
    }
}
