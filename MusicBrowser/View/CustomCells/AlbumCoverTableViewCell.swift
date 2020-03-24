//
//  AlbumCoverTableViewCell.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 24/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import UIKit

class AlbumCoverTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
