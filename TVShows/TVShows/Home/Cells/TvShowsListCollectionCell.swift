//
//  TvShowsListCollectionCell.swift
//  TVShows
//
//  Created by Infinum on 31/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import KeychainSwift

class TvShowsListCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var viewCell: UIView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var thumbnail: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setTheme()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setTheme()
        thumbnail.image = nil
        title.text = nil
    }
    
    @objc private func setTheme(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(keychain.get("theme") == "dark"){
            keychain.set("dark", forKey: "theme")
            keychain.synchronizable = true
            viewCell.backgroundColor = .darkGray
        } else {
            keychain.set("light", forKey: "theme")
            keychain.synchronizable = true
            viewCell.backgroundColor = .white
        }
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
        thumbnail.layer.cornerRadius = 15
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 15
    }
}
