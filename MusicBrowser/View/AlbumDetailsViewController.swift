//
//  AlbumDetailsViewController.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import UIKit
import Combine

class AlbumDetailsViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var album: Album?
    
    //View Model responsible for populating data
    private var trackViewModel = TrackViewModel()
    
    //Add subscriptions of combine request to make sure they execute.
    //Not having this will actually cancel the URIRequest
    var subscription = Set<AnyCancellable>()

    //Use Diffable datasource with section.
    fileprivate enum Section: CaseIterable {
        case main
    }
    
    fileprivate var dataSource: UITableViewDiffableDataSource<Section, Track>!
    
    //MARK:- Lifecycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupAlbumCover()
        
        let _ = trackViewModel.trackData
            .receive(on: RunLoop.main)
            .sink { [weak self] (tracks) in
                
                guard let `self` = self else {
                    return
                }
                self.createSnapshot(tracks)
        }
        .store(in: &subscription)
        if let albumID = album?.id {
            trackViewModel.retrieveAlbumDetails(String(albumID))
        }
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        setupDatasource()
    }

    fileprivate func setupAlbumCover() {
        coverImage.loadImageWithUrl(album?.coverXL ?? album?.coverBig ?? album?.coverMedium ?? "")
    }
}

// MARK:- Diffable DataSource Setup & UITableView Delegate methods -
extension AlbumDetailsViewController: UITableViewDelegate {
    
    fileprivate func setupDatasource() {
        
        dataSource = UITableViewDiffableDataSource<Section, Track>(tableView: tableView, cellProvider: { [weak self] (UITableView, indexPath, track) -> UITableViewCell? in
            
            guard let `self` = self else {
                return UITableViewCell()
            }
            
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as? TrackTableViewCell {
                cell.numberLabel.text = String(indexPath.row + 1)
                cell.titleLabel?.text = track.title
                if let duration = track.duration {
                    cell.durationLabel.text = String(duration)
                }
                return cell
            }
            
            return UITableViewCell()
        })
    }
    
    fileprivate func createSnapshot(_ tracks: [Track]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Track>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tracks)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselect the row.
        tableView.deselectRow(at: indexPath, animated: true)
        guard let track = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        //Preview playback
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 //Hardcode? Dynamic would be great here I believe.
    }
}
