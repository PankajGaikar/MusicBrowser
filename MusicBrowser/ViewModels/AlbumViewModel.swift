//
//  AlbumViewModel.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 23/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation
import Combine

class AlbumViewModel {
    
    var albumDataArray = [Album]()
    var albumData = CurrentValueSubject<[Album], Never>([])
    var subscription = Set<AnyCancellable>()
    var shouldFetchMoreData = true
    
    func retrieveSearchResults(_ artistID: String) {
        
        //TODO:- Add logic to stop this.
        
        if shouldFetchMoreData == false {
            return
        }
        
        let _ = APIManager.shared.retrieveAlbumsFor(artistID: artistID, index: albumDataArray.count)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (_) in
            
            }) { [weak self] (albumDataSet) in
                
                guard let `self` = self else {
                    return
                }
                
                if let albums = albumDataSet.albums {
                    self.albumDataArray.append(contentsOf: albums)
                    self.albumData.send(self.albumDataArray)
                }
                
                if self.albumDataArray.count >= albumDataSet.total! {
                    self.shouldFetchMoreData = false
                }
                
                //Convey no results found?
        }
        .store(in: &subscription)
    }
}
