//
//  TrackDetailView.swift
//  MySound
//
//  Created by Игорь Ноек on 24.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit


class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.backgroundColor = .red

    }
    

    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        
        self.removeFromSuperview()
        
    }
    
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
    }
    
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
    }
    
    
    @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
    }
    
    
    
}
