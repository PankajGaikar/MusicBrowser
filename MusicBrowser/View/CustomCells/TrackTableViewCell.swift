//
//  TrackTableViewCell.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 23/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
