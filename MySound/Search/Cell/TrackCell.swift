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
private var tracks: Results<Track>!

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionString: String { get }
}


class TrackCell: UITableViewCell {
    
    @IBOutlet weak var addTrack: UIButton!
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
        

        

        
 
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionLabel.text = viewModel.collectionString
        

        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    

 
    @IBAction func addTrackToLibraryTapped(_ sender: UIButton) {
        let track = Track(trackName: trackNameLabel.text!, artistName: artistNameLabel.text!, collectionName: collectionLabel.text!, previewUrl: "", saved: true)
        StorageManager.saveTracks(track)
        
        
    }
    
    
}
