//
//  ShowDetailsTableCell.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

final class ShowDetailsTableCell: UITableViewCell {
    
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var seasonNumberLabel: UILabel!
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeLabel.text = nil
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
       // thumbnail.layer.cornerRadius = 20
        episodeLabel.textColor = UIColor.black
    }
}
