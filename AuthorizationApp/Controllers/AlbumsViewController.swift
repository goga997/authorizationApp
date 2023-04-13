//
//  AlbumsViewController.swift
//  AuthorizationApp
//
//  Created by Grigore on 09.04.2023.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .lightGray
        tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let mySearchController = UISearchController(searchResultsController: nil)
    
    var albums = [Album]()
    var timer: Timer?
    
    //MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setDelegates()
        setConstraints()
        setNavigation()
        setSearController()
        
    }
    
    
    
    private func setUpView() {
        view.addSubview(tableView)
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        
        mySearchController.searchBar.delegate = self
    }
    
    private func setNavigation() {
        navigationItem.title = "Albums"
        navigationItem.searchController = mySearchController
        
        let userInfoButton = createCustomButton(selector: #selector(userInfoButtonTapped))
        navigationItem.rightBarButtonItem = userInfoButton
    }
    
    @objc private func userInfoButtonTapped() {
        let userInfoViewControler = UserInfoViewController()
        navigationController?.pushViewController(userInfoViewControler, animated: true)
    }
    
    private func setSearController() {
        mySearchController.searchBar.placeholder = "Search"
        mySearchController.obscuresBackgroundDuringPresentation = false
    }
    
    //parsing
    private func fetchAlbums(albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        
        
        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
            
            if error == nil {
                
                guard let albumModel = albumModel else { return }
                let sortedAlbums = albumModel.results.sorted { firstItem, secondItem in
                    return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
                }
                self?.albums = sortedAlbums
                self?.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

//MARK: -  TABLE VIEW DATA SOURCE


extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumsTableViewCell
        
        let album = albums[indexPath.row]
        cell.configureAlbumCell(album: album)
        
        return cell
    }
}

//MARK: - DELEGATES for table view

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumVC = DetailAlbumViewController()
        
        let album = albums[indexPath.row]
        detailAlbumVC.album = album
        detailAlbumVC.title = album.artistName
        
        navigationController?.pushViewController(detailAlbumVC, animated: true)
    }
}

//MARK: - DELEGATES FOR SEARCH BAR .. UISearchBar Delegates

extension AlbumsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if text != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.fetchAlbums(albumName: text!)
            })
        }
        tableView.reloadData()
    }
}

//MARK: - setez constraints

extension AlbumsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
        ])
    }
}
