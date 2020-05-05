//
//  TrackCell.swift
//  MySound
//
//  Created by Игорь Ноек on 22.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

//var track: Track!


protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionString: String { get }
}


class TrackCell: UITableViewCell {
    private var tracks: Results<Track>!

    @IBOutlet weak var addTrackOutlet: UIButton!
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    
    static let reuseId = "TrackCell"
    
    override func awakeFromNib() {//необходимо при конфигурации через .xib
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracks = realm.objects(Track.self)

        
        trackImageView.image = nil
    }
    
    var cell: SearchViewModel.Cell?
    
    func set(viewModel: SearchViewModel.Cell) {
        
        cell = viewModel
        tracks = realm.objects(Track.self)
        
        let savedTracks = tracks
        

        


        let hasFavourite = savedTracks?.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }

        
 
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionLabel.text = viewModel.collectionString
        

        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    
 
    @IBAction func addTrackToLibraryTapped(_ sender: UIButton) {
        let savedTracks = tracks

        
        let hasFavourite = savedTracks?.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFavourite != true {
            addTrackOutlet.isHidden = true
         let track = Track(trackName: cell!.trackName, artistName: cell!.artistName, collectionName: cell!.collectionString, previewUrl: cell?.previewUrl)
            StorageManager.saveTracks(track)
        } else {
            print("Item already exist")
        }
        

        
        
    }
    
    
}
