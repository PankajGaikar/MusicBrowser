//
//  ViewController.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import UIKit
import Combine

class ArtistsSearchViewController: UIViewController {

    //Tableview instance linked from storyboard
    @IBOutlet weak var tableView: UITableView!
    
    //Searchbar to be added to navigation bar
    lazy var searchBar = UISearchBar(frame: CGRect.zero)

    //View Model responsible for populating data
    private var artistViewModel = ArtistViewModel()
    
    //Add subscriptions of combine request to make sure they execute.
    //Not having this will actually cancel the URIRequest
    var subscription = Set<AnyCancellable>()

    //Use Diffable datasource with section.
    fileprivate enum Section: CaseIterable {
        case main
    }
    
    fileprivate var dataSource: UITableViewDiffableDataSource<Section, Artist>!
    
    //MARK:- Lifecycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup searchbar
        setupSearchBar()
        setupTableView()
        
        let _ = artistViewModel.artistData
            .receive(on: RunLoop.main)
            .sink { [weak self] (artist) in
                
                guard let `self` = self else {
                    return
                }
                self.createSnapshot(artist)
        }
        .store(in: &subscription)
    }

    //MARK:- Setup UI
    fileprivate func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.searchTextField.clearButtonMode = .always
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        setupDatasource()
    }

}

//MARK:- SearchBar delegate
extension ArtistsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        artistViewModel.retrieveSearchResults(searchText)
    }
}

// MARK:- Diffable DataSource Setup & UITableView Delegate methods -
extension ArtistsSearchViewController: UITableViewDelegate {
    
    fileprivate func setupDatasource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Artist>(tableView: tableView, cellProvider: { [weak self] (UITableView, indexPath, artist) -> UITableViewCell? in
            
            guard let `self` = self else {
                return UITableViewCell()
            }
            
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as? ArtistTableViewCell {
                cell.titleLabel?.text = artist.name
                cell.iconImageView.loadImageWithUrl(artist.picture ?? artist.pictureBig ?? artist.pictureMedium ?? "") //Try three URIs before giving up.
                return cell
            }
            
            return UITableViewCell()
        })
    }
    
    fileprivate func createSnapshot(_ artists: [Artist]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Artist>()
        snapshot.appendSections([.main])
        snapshot.appendItems(artists)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let artist = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        //Show albums screen
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 //Hardcode? Dynamic would be great here I believe.
    }
}

