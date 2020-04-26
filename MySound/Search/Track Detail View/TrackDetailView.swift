//
//  TrackDetailView.swift
//  MySound
//
//  Created by Игорь Ноек on 24.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: class {
    //delegate
    func moveBackForPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell?
}




class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false//задержка загрузки плеера
        return avPlayer
    }()
    
    
    weak var delegate: TrackMovingDelegate?
    
    
    // MARK: - Awake Frome Nib
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5//закругляем картинку
    }
    
    
    
    
    
    // MARK: - Setup
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }//извлекаем url песни
        let playerItem = AVPlayerItem(url: url)//создаём объект с этой песней
        player.replaceCurrentItem(with: playerItem)//кладём в плеер объект с песней
        player.play()
    }
    
    
    func set(viewModel: SearchViewModel.Cell) {
        
        trackTitleLabel.text = viewModel.trackName
        artistLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observeCurrentSongTime()
        
        let resizeOfImage = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: resizeOfImage ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: - Time Setup
    
    
    private func monitorStartTime() {
        //отслеживаем начало воспроизведения музыки
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in//утечка памяти при запуске нескольких треков
            
            self?.enlargeTrackImageView()
            
        }
        
    }
    
    private func observeCurrentSongTime() {
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            self?.currentTimeLabel.text = time.toDisplayString()
            
            
            let durationTime = self?.player.currentItem?.duration//общее время аудиофайла
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()//отображаем оставшееся время
            self?.durationTimeLabel.text = "-\(currentDurationText)"
            
            
            self?.updateCurrentTimeSlider()
            
        }
        
    }
    
    
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())//текущее время
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)) //дефолтное значени
        let percent =  currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percent)
    }
    
    
    
    
    // MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.trackImageView.transform = .identity
            
        }, completion: nil)
    }
    
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }, completion: nil)
        
    }
    
    // MARK: - IBActions
    
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        
        self.removeFromSuperview()
        
    }
    
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
        
        let percentage = currentTimeSlider.value//берём значение слайдера
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        let currentTimeInSeconds = Float64(percentage) * durationInSeconds
        let currentTime = CMTimeMakeWithSeconds(currentTimeInSeconds, preferredTimescale: 1)
        player.seek(to: currentTime)
    }
    
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    
    @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
        
        let cellViewModelDelegate = delegate?.moveBackForPreviousTrack()
        guard let cellViewModel = cellViewModelDelegate else { return }
        self.set(viewModel: cellViewModel)
        
    }
    
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        
        if player.timeControlStatus == .paused {//воспроизводим
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {//ставим на паузу
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }
        
    }
    
    
    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
        
        let cellViewModelDelegate = delegate?.moveForwardForPreviousTrack()
        guard let cellViewModel = cellViewModelDelegate else { return }
        self.set(viewModel: cellViewModel)
        
    }
    
    
    
}
