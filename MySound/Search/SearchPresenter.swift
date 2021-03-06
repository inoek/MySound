//
//  SearchPresenter.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright (c) 2020 Игорь Ноек. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
//готовит данные к отображению


protocol SearchPresentationLogic
{
    func presentData(response: Search.Model.Response.ResponseType)//added
}

class SearchPresenter: SearchPresentationLogic
{
    weak var viewController: SearchDisplayLogic?//updated
    
    func presentData(response: Search.Model.Response.ResponseType) {
        
        switch response {
            
        case .presentTracks(let searchResults):
            //конвертируем полученные треки в формат и отправляем данные в ViewController
            let cells = searchResults?.results.map({ (track) in
                //возвращаем в searchResults объект track, содержащий элементы модели TrackModel
                cellViewModel(from: track)
            }) ?? [] //обрабатываем ошибку - возвращаем пустой массив
            
            let searchViewModel = SearchViewModel.init(cells: cells)
            viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel))
        //отправляем во viewController footerView
        case .presentFooterView:
            viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayFooterView)
        }
        
        
        
        
        
    }
    private func cellViewModel(from track: TrackModel) -> SearchViewModel.Cell {
        
        return SearchViewModel.Cell.init(iconUrlString: track.artworkUrl100,
                                         trackName: track.trackName,
                                         collectionName: track.collectionName ?? "",
                                         artistName: track.artistName,
                                         previewUrl: track.previewUrl)
    }
    
}
