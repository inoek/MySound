//
//  TrackCell.swift
//  MySound
//
//  Created by Игорь Ноек on 22.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionString: String { get }
}


class TrackCell: UITableViewCell {
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    
    static let reuseId = "TrackCell"
    
    override func awakeFromNib() {//необходимо при конфигурации через .xib
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImageView.image = nil
    }
    
    var cell: SearchViewModel.Cell?

    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavourite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFavourite {
            addButtonOutlet.isHidden = true
        } else {
            addButtonOutlet.isHidden = false
        }

        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
   
    @IBAction func addTrackButton(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        guard let cell = cell else { return }
        addButtonOutlet.isHidden = true
        
        var listOfTracks = defaults.savedTracks()
        
        listOfTracks.append(cell)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            print("Успешно!")
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}
