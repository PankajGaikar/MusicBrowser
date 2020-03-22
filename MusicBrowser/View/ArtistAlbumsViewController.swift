//
//  ArtistAlbumsViewController.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import UIKit

class ArtistAlbumsViewController: UIViewController {

    var artist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = artist?.name
    
    }
    
}
