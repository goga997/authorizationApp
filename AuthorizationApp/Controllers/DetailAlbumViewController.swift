//
//  DetailAlbumViewController.swift
//  AuthorizationApp
//
//  Created by Grigore on 09.04.2023.
//

import UIKit

class DetailAlbumViewController: UIViewController {
    
    private let albumLogo: UIImageView = {
       let image = UIImageView()
        
        image.backgroundColor = .red
        image.clipsToBounds = true
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let albumNameLabel: UILabel = {
       let lb = UILabel()
        
        lb.numberOfLines = 0
        lb.text = "Name album "
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let artistNameLabel: UILabel = {
       let lb = UILabel()
        
        lb.text = "Name artist "
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let releaseDateLabel: UILabel = {
       let lb = UILabel()
        
        lb.text = "Release Date "
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let countTracksLabel: UILabel = {
       let lb = UILabel()
        
        lb.text = "15 tracks "
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    //MARK: - creating Colection VIew
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(SongsColectionViewCell.self, forCellWithReuseIdentifier: "cell")

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var stackView = UIStackView()
    
    var album: Album?
    var songs = [Song]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        setUpView()
        setConstraints()
        setDelegates()
        setModel()
        fetchSongs(album: album)
    }
    
    private func setUpView() {
        view.addSubview(albumLogo)
        stackView = UIStackView(arangedSubViews: [albumNameLabel,artistNameLabel, releaseDateLabel, countTracksLabel], axis: .vertical, spacing: 10, distribution: .fillProportionally)
        
        view.addSubview(stackView)
        view.addSubview(collectionView)
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setModel() {
        //updatez datele
        
        guard let album = album else { return }
        
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        countTracksLabel.text = "\(album.trackCount) tracks:"
        releaseDateLabel.text = setDateFormat(date: album.releaseDate)
        
        guard  let url = album.artworkUrl100 else { return }
        setImage(urlString: url)
    }
    
    private func setDateFormat(date: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let backendDate = dateformatter.date(from: date) else { return "" }
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let date = formatDate.string(from: backendDate)
        
        return date
    }
    
    private func setImage(urlString: String?) {
        if let url = urlString {
            NetworkRequest.shared.requestData(urlString: url) { [weak self]result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.albumLogo.image = image
                case .failure(let error):
                    self?.albumLogo.image = nil
                    print("NonalbumLogoo" + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
    }
    
    private func fetchSongs(album: Album?) {
        guard let album = album else { return }
        
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"

        NetworkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else { return }
                self?.songs = songModel.results
                self?.collectionView.reloadData()
            } else {
                print(error!.localizedDescription)
                self?.alertOk(title: "error", message: error!.localizedDescription)
            }
        }
    }
    
    
}

//MARK: - setez delegates si data source pentru Colection view meu

extension DetailAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        songs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongsColectionViewCell
        
        let song = songs[indexPath.row].trackName
        cell.nameSongLabel.text = song
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 20)
    }
}

//MARK: - CONSTR

extension DetailAlbumViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            albumLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            albumLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumLogo.heightAnchor.constraint(equalToConstant: 100),
            albumLogo.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}
