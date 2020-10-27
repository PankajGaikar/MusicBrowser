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

    @IBOutlet weak var tableView: UITableView!
    var album: Album?
    
    //View Model responsible for populating data
    private var trackViewModel = TrackViewModel()
    
    //Add subscriptions of combine request to make sure they execute.
    //Not having this will actually cancel the URIRequest
    var subscription = Set<AnyCancellable>()

    //Use Diffable datasource with section.
    fileprivate enum Section: CaseIterable {
        case albumCover
        case main
    }
    
    //Set datasource as diffable just to make sure it can have both Album and Track objects.
    fileprivate var trackDataSource: UITableViewDiffableDataSource<Section, AnyHashable>!

    //MARK:- Lifecycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let albumName = album?.title {
            self.navigationItem.title = albumName
        }
        
        //Setup delegate and datasource
        setupTableView()
        
        //Setup subscriber.
        let _ = trackViewModel.trackData
            .receive(on: RunLoop.main)
            .sink { [weak self] (tracks) in
                
                guard let `self` = self else {
                    return
                }
                self.createSnapshot(tracks)
        }
        .store(in: &subscription)
        
        //Fetch data
        if let albumID = album?.id {
            trackViewModel.retrieveAlbumDetails(String(albumID))
        }
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        setupDatasource()
    }

}

// MARK:- Diffable DataSource Setup & UITableView Delegate methods -
extension AlbumDetailsViewController: UITableViewDelegate {
    
    fileprivate func setupDatasource() {
        
        //Create datasource instance
        trackDataSource = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableView, cellProvider: { (tableView, indexPath, object) -> UITableViewCell? in
            
            switch object {
                //This is going to be album
                case let object as Album:
                    if let cell = self.tableView.dequeueReusableCell(withIdentifier: "AlbumCoverTableViewCell", for: indexPath) as? AlbumCoverTableViewCell {
                        cell.coverImageView.loadImageWithUrl(object.coverXL ?? "")
                        return cell
                    }
                    
                //Setup tracks.
                case let object as Track:
                    if let cell = self.tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as? TrackTableViewCell {
                        cell.numberLabel.text = String(indexPath.row + 1)
                        cell.titleLabel?.text = object.title
                        cell.durationLabel.text = object.durationInString
                        return cell
                    }
                default: break
                }
                return UITableViewCell()
            
        })
    }
    
    fileprivate func createSnapshot(_ tracks: [Track]) {
        var trackSnapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        trackSnapshot.appendSections(Section.allCases)
        trackSnapshot.appendItems([album!], toSection: .albumCover)
        trackSnapshot.appendItems((tracks), toSection: .main)
        trackDataSource.apply(trackSnapshot, animatingDifferences: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselect the row.
        tableView.deselectRow(at: indexPath, animated: true)
        guard let track = trackDataSource.itemIdentifier(for: indexPath) else {
            return
        }

        //Preview playback
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UIScreen.main.bounds.width
        }
        return 64 //Hardcode? Constant would be great here I believe.
    }


}

