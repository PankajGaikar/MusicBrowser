//
//  ViewController.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import UIKit

class ArtistsSearchViewController: UIViewController {

    lazy var searchBar = UISearchBar(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup searchbar
        setupSearchBar()
    }

    fileprivate func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.searchTextField.clearButtonMode = .always
        navigationItem.titleView = searchBar
    }

}

