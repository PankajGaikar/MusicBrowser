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
    var durationInString: String {
        return getDurationString(duration: duration ?? 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, readable, title, link, duration, rank, preview, artist
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case explicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
    }
}

func getDurationString(duration: Int) -> String {
    let minute = duration / 60 % 60
    let second = duration % 60
    return String(format: "%02i:%02i", minute, second)
}

struct TrackDataSet: Codable, Hashable  {
    
    let tracks: [Track]?
    
    enum CodingKeys: String, CodingKey {
        case tracks = "data"
    }
}
