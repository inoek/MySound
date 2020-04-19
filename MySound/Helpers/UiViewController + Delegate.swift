//
//  UiViewController + Delegate.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit


extension UIViewController {
    //функция ищет в проекте файла типа /storyboard. T - generic тип
    class func loadFromStoryboard<T: UIViewController>() -> T {
        
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            
            return viewController
        } else {
            fatalError("No initial view controller in \(name) storyboard")
        }
    }
}
