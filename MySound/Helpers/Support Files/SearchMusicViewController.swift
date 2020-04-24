//
//  SearchMusicViewController.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import Alamofire

//struct ww {
//    var artistName: String
//    var trackName: String
//}


class SearchMusicViewController: UITableViewController {
    
    var networkService = NetworkService()
    private var timer: Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [TrackModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSearchBar()
        
        //регистрируем ячейку
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
    }
    
    private func setupSearchBar() {
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self //выполняет расширение
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let track = tracks[indexPath.row]
        
        
        cell.textLabel?.text = "\(track.artistName)\n\(track.trackName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
}


extension SearchMusicViewController: UISearchBarDelegate {
    //срабатывает каждый раз при вводе текста в поисковую строку
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()//инициализация таймера
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchTracks(searchText: searchText) {[weak self] (searchResults) in
                
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
            }
            
   
        })

    }
}
