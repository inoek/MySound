//
//  Starage Manager.swift
//  MySound
//
//  Created by Игорь Ноек on 30.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import RealmSwift


let realm = try! Realm()

class StorageManager {
    
    static func saveTracks(_ track: Track) {
        try! realm.write {
            realm.add(track)
        }
    }
    
    
    static func deleteObject(_ track: Track) {
        try! realm.write {
            realm.delete(track)
        }
    }
    
    
}
