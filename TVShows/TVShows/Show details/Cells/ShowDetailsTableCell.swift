//
//  ShowDetailsTableCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import KeychainSwift

final class ShowDetailsTableCell: UITableViewCell {
    
    @IBOutlet private weak var episodeLabel: UILabel!
    @IBOutlet private weak var episodeNumberLabel: UILabel!
    @IBOutlet private weak var seasonNumberLabel: UILabel!
    @IBOutlet private weak var contentViewCell: UIView!
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeLabel.text = nil
    }
    
    @objc private func setTheme(){
        
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        
        if(keychain.get("theme") == "dark"){
            contentViewCell.backgroundColor = .darkGray
            contentViewCell.tintColor = .lightGray
            episodeLabel.backgroundColor = .darkGray
            episodeNumberLabel.backgroundColor = .darkGray
            seasonNumberLabel.backgroundColor = .darkGray
        } else {
            contentViewCell.backgroundColor = .darkGray
            contentViewCell.tintColor = .darkGray
            episodeLabel.backgroundColor = .white
            episodeNumberLabel.backgroundColor = .white
            seasonNumberLabel.backgroundColor = .white
        }
    }
}

// MARK: - Configure
extension ShowDetailsTableCell {
    func configure(with item: Episodes) {
        seasonNumberLabel.text = "S" + item.season
        episodeNumberLabel.text = "Ep" + item.episodeNumber
        episodeLabel.text = item.title
    }
}

// MARK: - Private
private extension ShowDetailsTableCell {
    func setupUI() {
        episodeLabel.textColor = UIColor.black
    }
}
