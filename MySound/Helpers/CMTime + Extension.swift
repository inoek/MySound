//
//  CMTime + Extension.swift
//  MySound
//
//  Created by Игорь Ноек on 25.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        //конвертируем непонятный тип в строковые миу=нуты и секунды
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))//общее количество секунд
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeForString = String(format: "%02d:%02d", minutes, seconds)//создаём свой формат
        return timeForString
    }
    
}
