//
//  Track.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 23/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation

struct Track: Codable, Hashable {
    let id: Int?
    let readable: Bool?
    let title: String?
    let titleShort: String?
    let titleVersion: String?
    let duration: Int?
    let rank: Int?
    let link: String?
    let explicitLyrics: Bool?
    let explicitContentLyrics: Int?
    let explicitContentCover: Int?
    let preview: String?
    let artist: Artist?
    
    enum CodingKeys: String, CodingKey {
        case id, readable, title, link, duration, rank, preview, artist
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case explicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
    }
}

struct TrackDataSet: Codable, Hashable  {
    
    let tracks: [Track]?
    
    enum CodingKeys: String, CodingKey {
        case tracks = "data"
    }
}
