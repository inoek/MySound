//
//  SearchRespondModel.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import Foundation


struct RespondModel: Decodable {
    var resultCount: Int
    var results: [TrackModel]
}

struct TrackModel: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
