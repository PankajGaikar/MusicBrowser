//
//  TrackViewModel.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 23/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation
import Combine

class TrackViewModel {
    
    var trackDataArray = [Track]()
    var trackData = CurrentValueSubject<[Track], Never>([])
    var subscription = Set<AnyCancellable>()
    
    func retrieveAlbumDetails(_ albumID: String) {
        
        let _ = APIManager.shared.retrieveAlbumsDetails(albumID: albumID)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (_) in
            
            }) { [weak self] (album) in
                
                guard let `self` = self else {
                    return
                }
                
                if let tracks = album.trackDataSet?.tracks {
                    self.trackDataArray = tracks
                    self.trackData.send(tracks)
                }
                
                //Convey no results found?
        }
        .store(in: &subscription)
    }
}
