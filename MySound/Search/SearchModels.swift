//
//  SearchModels.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright (c) 2020 Игорь Ноек. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Search
{
  // MARK: Use cases
  
  enum Model
  {
    
    struct Request
    {
        enum RequestType {
            case getTracks(searchTerm: String)
        }
    }
    
    
    struct Response
    {
        enum ResponseType {
            case presentTracks(searchResponse: RespondModel?)
            case presentFooterView
        }
    }
    
    
    struct ViewModel
    {
        enum ViewModelData {
            case displayTracks(searchViewModel: SearchViewModel)
            case displayFooterView
        }
        
    }
    
  }

}
struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var collectionString: String
        
        var iconUrlString: String?
        var trackName: String
       //var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    let cells: [Cell]
}
//TrackModel
//class SearchViewModel: NSObject, NSCoding {
//    func encode(with coder: NSCoder) {
//        //преобразует свойства класса к сохранению
//        coder.encode(cells, forKey: "cells")
//    }
//
//    required init?(coder: NSCoder) {
//        cells = coder.decodeObject(forKey: "cells") as? [SearchViewModel.Cell] ?? []
//    }
//
//    @objc(_TtCC7MySound15SearchViewModel4Cell)class Cell: NSObject, NSCoding {
//
//        func encode(with coder: NSCoder) {
//            coder.encode(iconUrlString, forKey: "iconUrlString")
//            coder.encode(trackName, forKey: "trackName")
//            coder.encode(artistName, forKey: "artistName")
//            coder.encode(collectionString, forKey: "collectionString")
//            coder.encode(previewUrl, forKey: "previewUrl")
//        }
//
//        required init?(coder: NSCoder) {
//            iconUrlString = coder.decodeObject(forKey: "iconUrlString") as? String? ?? ""
//            trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
//            artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
//            collectionString = coder.decodeObject(forKey: "collectionString") as? String ?? ""
//            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String? ?? ""
//        }
//
//        var iconUrlString: String?
//
//        var trackName: String
//
//        var artistName: String
//
//        var collectionString: String
//
//        var previewUrl: String?
//
//        init(iconUrlString: String?,
//             trackName: String,
//             artistName: String,
//             collectionString: String,
//             previewUrl: String?) {
//            self.iconUrlString = iconUrlString
//            self.trackName = trackName
//            self.artistName = artistName
//            self.collectionString = collectionString
//            self.previewUrl = previewUrl
//        }
//    }
//
//    init(cells: [Cell]) {
//        self.cells = cells
//    }
//
//    let cells: [Cell]
//}
