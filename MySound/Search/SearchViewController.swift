//
//  SearchViewController.swift
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

protocol SearchDisplayLogic: class
{
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)//add
}

class SearchViewController: UIViewController, SearchDisplayLogic
{
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    
    @IBOutlet weak var table: UITableView!
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    private var timer: Timer?
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    
    //lazy - не будет инициализировать экземпляр, пока его объект не понадобится
    private lazy var footerView = FooterView()
    
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
        setupTableView()
        setupSearchBar()
        //заполнение searchBar
        //searchBar(searchController.searchBar, textDidChange: "travis scott")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let keyWindow = UIApplication.shared.connectedScenes.filter( {
            $0.activationState == .foregroundActive
        }).map({ $0 as? UIWindowScene }).compactMap({
            $0
            }).first?.windows.filter({ $0.isKeyWindow }).first
        //получаем keyWindow
        
        let tabbarVC = keyWindow?.rootViewController as? MainTabBarController
        tabbarVC?.trackDetailView.delegate = self
        //при нажатии на кнопку с окна библиотеки меняется делегат
    }
    
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupTableView() {
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //регистрируем .xib кастомную ячейку
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        table.tableFooterView = footerView
        
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
            
        case .displayFooterView:
            footerView.showLoader()//показываем ФВ при загрузке данных
        case .displayTracks(let searchViewModel):
            //локальная переменная получает полученные данные
            self.searchViewModel = searchViewModel
            table.reloadData()
            footerView.hideLoader()//скрываем footerView при загрузке данных
            
        }
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell //кастим ячейку к TrackCell
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        
        cell.set(viewModel: cellViewModel)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        
        self.tabBarDelegate?.maximizedTrackDetailController(viewModel: cellViewModel)
//        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
//        let window = UIApplication.shared.keyWindow//главное окно приложения
//        trackDetailView.set(viewModel: cellViewModel)
//        trackDetailView.delegate = self//объявляем делегата (SearchViewController отвечает за реализацию функций)
//        window?.addSubview(trackDetailView)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "Введите запрос в поиск"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //отправляем запрос в Interactor при вводе текста в поисковую строку
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
    }
}

extension SearchViewController: TrackMovingDelegate {
    
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)//снимаем выделение ячейки
        var nextIndexPath: IndexPath
        
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            //если выходим за пределы списка
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            //если выходим за пределы списка
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
            }
        }
        
        //выделяем новую ячейку
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModell = searchViewModel.cells[nextIndexPath.row]
        return cellViewModell
    }
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: false)//false - трек предыдущий
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: true)
    }
    
    
}
