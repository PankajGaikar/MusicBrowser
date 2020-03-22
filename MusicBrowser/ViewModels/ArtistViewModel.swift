//
//  ArtistViewModel.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation
import Combine

class ArtistViewModel {
    
    var artistDataArray = [Artist]()
    var artistData = CurrentValueSubject<[Artist], Never>([])
    var subscription = Set<AnyCancellable>()

    func retrieveSearchResults(_ artist: String) {
        
        let _ = APIManager.shared.retrieveSearchResults(artist: artist)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (_) in
            
            }) { [weak self] (artistDataset) in
                
                guard let `self` = self else {
                    return
                }
                
                if let artists = artistDataset.artists {
                    self.artistDataArray = artists
                    self.artistData.send(artists)
                }
                
                //Convey no results found?
        }
        .store(in: &subscription)
    }
}
