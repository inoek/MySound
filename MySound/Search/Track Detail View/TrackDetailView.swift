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

protocol TrackMovingDelegate {
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
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    //MARK: -Mini Players Outlets
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    
    
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false//задержка загрузки плеера
        return avPlayer
    }()
    
    
     var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate? //делегат протокола МТБК
    
    
    // MARK: - Awake Frome Nib
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5//закругляем картинку
        
        setupGestures()
        
        //изменяем размер кнопки в мини плеере
        //сужаем картинку на 11 поинтов по каждой стороне
        miniPlayPauseButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
    }
    
    
    
    
    
    // MARK: - Setup
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }//извлекаем url песни
        let playerItem = AVPlayerItem(url: url)//создаём объект с этой песней
        player.replaceCurrentItem(with: playerItem)//кладём в плеер объект с песней
        player.play()
    }
    
    
    func set(viewModel: SearchViewModel.Cell) {
        //мини плеер
        miniTrackTitleLabel.text = viewModel.trackName
        
        
        
        //настраиваем trackDetailView
        trackTitleLabel.text = viewModel.trackName
        artistLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observeCurrentSongTime()
        
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        
        let resizeOfImage = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: resizeOfImage ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        //после того, как вы вытащили url, добавляем картинку для мини плеера
        miniTrackImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func setupGestures() {
        //срабатывает только при тапе по мини трек вью
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        //срабатывает при перетягивании mini player вверх
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        //сворачивание главного экрана
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDissmisalPan)))
    }
    
    
    //MARK: - Maximized and Minimized geastures setup
    
    @objc private func handleTapMaximized() {
        //вызываем функцию включения большого trackView
        self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {

        case .began:
            print("began")
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        @unknown default:
            print("unknown default")
        }
    }
    
    @objc private func handleDissmisalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            //отслеживаем координату у при использовании жестов
            let translation = gesture.translation(in: self.superview)
            //двигаем главный элементы trackView в след за пальцем
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let velocity = gesture.velocity(in: self.superview)
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                //код анимации
                self.maximizedStackView.transform = .identity
                if translation.y > 300 || velocity.y > 300{
                    self.tabBarDelegate?.minimizedTrackDetailController()
                }

            }, completion: nil)
        @unknown default:
            print("unknown default")
        }
    }
    
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        
        let newAlpha = 1 + translation.y / 200 //устанавливаем уровень прозрачности в зависимости от положения экрана
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)//скорость перетягивания
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity//устанавливаем изначальное положение представления
            //анимация
            if translation.y < -200 || velocity.y < -500 {
                //если подняли выше 200 точек или скорость выше 500, то поднимаем
                self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }, completion: nil)
        
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
        //отслеживаем текущее время композиции
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
        
        //self.removeFromSuperview()
        //вызываем через делегата функцию уменьшения
        self.tabBarDelegate?.minimizedTrackDetailController()
        
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
        //тут две кнопки плей/пауз
        if player.timeControlStatus == .paused {//воспроизводим
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)

            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {//ставим на паузу
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
            
        }
        
    }
    
    
    
    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
        //тут тоже две кнопки
        let cellViewModelDelegate = delegate?.moveForwardForPreviousTrack()
        guard let cellViewModel = cellViewModelDelegate else { return }
        self.set(viewModel: cellViewModel)

        
    }

}

