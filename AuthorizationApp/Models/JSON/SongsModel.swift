//
//  SongsModel.swift
//  AuthorizationApp
//
//  Created by Grigore on 12.04.2023.
//

import Foundation

struct SongsModel: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackName: String?
}


