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

    @IBOutlet weak var tableView: UITableView!
    lazy var searchBar = UISearchBar(frame: CGRect.zero)

    private var artistViewModel = ArtistViewModel()
    var subscription = Set<AnyCancellable>()

    fileprivate enum Section: CaseIterable {
        case main
    }
    
    fileprivate var dataSource: UITableViewDiffableDataSource<Section, Artist>!
    
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
                print("Incoming data")
                self.createSnapshot(artist)
        }
        .store(in: &subscription)
    }

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
        return 64
    }
}

