//
//  FooterView.swift
//  MySound
//
//  Created by Игорь Ноек on 22.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    private var myLabel: UILabel = {
       
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        
        return label
    }()
    
    private var loader: UIActivityIndicatorView = {
        
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true//пропадает, когда останавливается
        
        return loader
    }()
    
    //дефолтные инициализаторы
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElements()
    }
    
    
    private func setupElements() {
        addSubview(myLabel)
        addSubview(loader)
        
        //констреинты через код
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true//левый
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true//правый
        
        //закрепляем иконку загрузки по центру
        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //располагаем текстовый label на 8 поинтов выше лоадера
        myLabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }
    
    func showLoader() {
        loader.startAnimating()//крутимся
        myLabel.text = "Загрузка"
    }
    
    
    func hideLoader() {
        loader.stopAnimating()
        myLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
