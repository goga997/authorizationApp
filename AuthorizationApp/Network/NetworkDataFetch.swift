//
//  NetworkDataFetch.swift
//  AuthorizationApp
//
//  Created by Grigore on 12.04.2023.
//

import Foundation

class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchAlbum(urlString: String, responce: @escaping (AlbumModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
                
            case .success(let data ):
                do {
                    let albums = try JSONDecoder().decode(AlbumModel.self, from: data)
                    responce(albums, nil)
                } catch  let jsonError {
                    print("Failled to decode json", jsonError)
                }
            case .failure(let error):
                print("error received request data \(error.localizedDescription)")
                responce(nil, error)
            }
        }
        
    }
    
    
    
    func fetchSongs(urlString: String, responce: @escaping (SongsModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
                
            case .success(let data ):
                do {
                    let albums = try JSONDecoder().decode(SongsModel.self, from: data)
                    responce(albums, nil)
                } catch  let jsonError {
                    print("Failled to decode json", jsonError)
                }
            case .failure(let error):
                print("error received request data \(error.localizedDescription)")
                responce(nil, error)
            }
        }
        
    }
    
}
