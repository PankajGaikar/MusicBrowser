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
        
        let uri = URL(string: APIKeys.BASE_URI + APIKeys.EndPoints.SEARCH + artist)
        return APIService.shared.connectAPI(uri!)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
}
