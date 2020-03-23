//
//  Album.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 23/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation

struct Album: Codable, Hashable {
    let id: Int?
    let title: String?
    let link: String?
    let cover: String?
    let coverSmall: String?
    let coverMedium: String?
    let coverBig: String?
    let coverXL: String?
    let genreID: Int?
    let fans: Int?
    let releaseDate: String?
    let recordType: String?
    let tracklist: String?
    let explicitLyrics: Bool?
    let type: String?
    let trackDataSet: TrackDataSet?
    
    enum CodingKeys: String, CodingKey {
        case id, title, link, cover, fans, tracklist, type
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXL = "cover_xl"
        case genreID = "genre_id"
        case releaseDate = "release_date"
        case explicitLyrics = "explicit_lyrics"
        case recordType = "record_type"
        case trackDataSet = "tracks"
    }
}

struct AlbumDataSet: Codable, Hashable  {
    
    let albums: [Album]?
    let total: Int?
    let next: String?
    
    enum CodingKeys: String, CodingKey {
        case total, next
        case albums = "data"
    }
}
