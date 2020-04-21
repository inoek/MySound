//
//  TrackCell.swift
//  MySound
//
//  Created by Игорь Ноек on 22.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionString: String { get }
}


class TrackCell: UITableViewCell {
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    
    static let reuseId = "TrackCell"
    
    override func awakeFromNib() {//необходимо при конфигурации через .xib
        super.awakeFromNib()
    }
    
    
    func set(viewModel: TrackCellViewModel) {
        
        
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionLabel.text = viewModel.collectionString
    }
    
    
    
}
