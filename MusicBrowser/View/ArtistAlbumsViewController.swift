//
//  ArtistAlbumsViewController.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import UIKit
import Combine

class ArtistAlbumsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var artist: Artist?
    
    //View Model responsible for populating data
    private var albumViewModel = AlbumViewModel()
    
    //Add subscriptions of combine request to make sure they execute.
    //Not having this will actually cancel the URIRequest
    var subscription = Set<AnyCancellable>()

    //Use Diffable datasource with section.
    fileprivate enum Section: CaseIterable {
        case main
    }
    
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, Album>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = artist?.name
    
        setupCollectionView()
        
        let _ = albumViewModel.albumData
            .receive(on: RunLoop.main)
            .sink { [weak self] (albums) in
                
                guard let `self` = self else {
                    return
                }
                self.createSnapshot(albums)
        }
        .store(in: &subscription)

        if let artistID = artist?.id {
            albumViewModel.retrieveSearchResults(String(artistID))
        }
        else {
            //Hmm, should this case be handled?
            print("No artistID, should not be on this screen.")
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self

        //Create default flowlayout for 2*2 grid
        //TOOD:- Remove hardcode values and add them in constants.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        //Width to be half of screen size.
        //Since image is square, height is same as width plus label height.
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/2 - 10, height: (UIScreen.main.bounds.size.width/2 * 1.2))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout

        setupDatasource()
    }
    
}

//MARK:- UICollectionVie3w Diffable Datasource and Delegates
extension ArtistAlbumsViewController: UICollectionViewDelegate {
    
    //Setup datasource
    fileprivate func setupDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Album>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, album) -> UICollectionViewCell? in

            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as? AlbumCollectionViewCell {
                cell.iconImageView.loadImageWithUrl(album.coverMedium ?? album.coverBig ?? "")
                cell.titleLabel.text = album.title
                return cell
            }

            return UICollectionViewCell()
        })
    }
    
    //Create snapshot
    fileprivate func createSnapshot(_ albums: [Album]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Album>()
        snapshot.appendSections([.main])
        snapshot.appendItems(albums)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    //Load more data once last cell is visible
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == albumViewModel.albumDataArray.count - 1 {
            if let artistID = artist?.id {
                albumViewModel.retrieveSearchResults(String(artistID))
            }
        }
    }
    
    //Did select item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Deselect the row.
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let album = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let albumDetailsViewController = self.storyboard?.instantiateViewController(identifier: "AlbumDetailsViewController") as! AlbumDetailsViewController
        albumDetailsViewController.album = album
        self.navigationController?.pushViewController(albumDetailsViewController, animated: true)
    }
}

//MARK:- CollectionView FlowLayout
//Setup grid to be shown, 2*2 in portrait and 4*4 in landscape.
extension ArtistAlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 10
        var numberOfGrids = 2
        
        //If orientation becomes landscape, make sure grid size is changed to four from two.
        //If screen height is less than width, we are in landscape orientation.
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            numberOfGrids = 4
        }
        
        let width = collectionView.frame.size.width / CGFloat(numberOfGrids) - CGFloat(padding)
        
        let height = width * 1.2
        return CGSize(width: width, height: height)
    }
}
