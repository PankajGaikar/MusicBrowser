//
//  APIManager.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation
import Combine

class APIManager {
    
    //MARK:- Shared instance
    static let shared = APIManager()

    //MARK:- Search Results
    func retrieveSearchResults(artist: String) -> AnyPublisher<ArtistDataSet, Error> {
        
        let uriString = APIKeys.BASE_URI + APIKeys.EndPoints.SEARCH + artist
        let uri = URL(string: uriString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        return APIService.shared.connectAPI(uri!)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    //MARK:- Artist Albums
    func retrieveAlbumsFor(artistID: String, index: Int) -> AnyPublisher<AlbumDataSet, Error> {
           
        let uri = URL(string: APIKeys.BASE_URI + APIKeys.EndPoints.ARTIST + artistID + APIKeys.EndPoints.ARTIST_ALBUMS + String(index))
           return APIService.shared.connectAPI(uri!)
               .map(\.value)
               .eraseToAnyPublisher()
       }
    
}
