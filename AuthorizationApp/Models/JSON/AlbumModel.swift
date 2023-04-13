//
//  AlbumModel.swift
//  AuthorizationApp
//
//  Created by Grigore on 12.04.2023.
//

import Foundation

struct AlbumModel: Decodable {
    let results: [Album]
    
}

struct Album: Decodable {
    let artistName: String
    let collectionName: String
    let artworkUrl100: String?
    let trackCount: Int
    let releaseDate: String
    let collectionId: Int
}
