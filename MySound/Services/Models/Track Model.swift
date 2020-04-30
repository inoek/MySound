//
//  Track Model.swift
//  MySound
//
//  Created by Игорь Ноек on 30.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import RealmSwift

class Track: Object {
    
    @objc dynamic var trackName: String = ""
    @objc dynamic var artistName: String = ""
    @objc dynamic var collectionString: String = ""
    @objc dynamic var previewUrl: String?
    @objc dynamic var saved: Bool = false
    
    
    convenience init(trackName: String,
                     artistName: String,
                     collectionName: String,
                     previewUrl: String?,
                     saved: Bool) {
        
        self.init()
        self.trackName = trackName
        self.artistName = artistName
        self.collectionString = collectionName
        self.previewUrl = previewUrl
        self.saved = saved
    }
}
