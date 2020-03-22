//
//  Artist.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation

struct Artist: Codable, Hashable {
    let id: Int?
    let name: String?
    let link: String?
    let picture: String?
    let pictureSmall: String?
    let pictureMedium: String?
    let pictureBig: String?
    let pictureXL: String?
    let nbAlbum: Int?
    let nbFan: Int?
    let radio: Bool?
    let tracklist: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, picture, radio, tracklist, type
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXL = "picture_xl"
        case nbAlbum = "nb_album"
        case nbFan = "nb_fan"
    }
}

struct ArtistDataSet: Codable, Hashable  {
    let artists: [Artist]?
    let total: Int?
    let next: String?
    
    enum CodingKeys: String, CodingKey {
        case total, next
        case artists = "data"
    }
}
