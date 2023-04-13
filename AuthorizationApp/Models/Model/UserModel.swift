//
//  UserModel.swift
//  AuthorizationApp
//
//  Created by Grigore on 12.04.2023.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let phone: String
    let mail: String
    let password: String
    let age: Date
}
