//
//  AlbumsTableViewCell.swift
//  AuthorizationApp
//
//  Created by Grigore on 09.04.2023.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {
    
    private let albumLogo: UIImageView = {
       let image = UIImageView()
        
        image.backgroundColor = .red
        image.clipsToBounds = true
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let albumNameLabel: UILabel = {
       let lb = UILabel()
        
        lb.text = "Name album name"
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let artistNameLabel: UILabel = {
       let lb = UILabel()
        
        lb.text = "Name artist name"
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let tracksCountLabel: UILabel = {
       let lb = UILabel()
        
        lb.text = "14 tracks"
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var stackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumLogo.layer.cornerRadius = albumLogo.frame.width / 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setView() {
        
        self.selectionStyle = .none
       self.backgroundColor = .clear
        self.addSubview(albumLogo)
       self.addSubview(albumNameLabel)
       stackView = UIStackView(arangedSubViews: [artistNameLabel, tracksCountLabel], axis: .horizontal, spacing: 10, distribution: .equalCentering)
       self.addSubview(stackView)

    }
    
    
    func configureAlbumCell(album: Album) {
        
        if let urlString = album.artworkUrl100 {
            NetworkRequest.shared.requestData(urlString: urlString) { [weak self]result in
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
        
        
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        tracksCountLabel.text = "\(album.trackCount)"
    }
    
   private func setConstraints() {
        NSLayoutConstraint.activate([
            albumLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            albumLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            albumLogo.heightAnchor.constraint(equalToConstant: 60),
            albumLogo.widthAnchor.constraint(equalToConstant: 60)
        ])
       
       NSLayoutConstraint.activate([
        albumNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        albumNameLabel.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
        albumNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1),
       ])
       
       NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 10),
        stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
       ])
    }
    
    
}
